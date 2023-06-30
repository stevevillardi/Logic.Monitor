Function Start-LMSessionSyncServer {
    Param(
        [Switch]$EnableRequestLogging,
        [Switch]$EnableErrorLogging
    )
    Begin {
        #Ensure we have a vault to use for storing session details
        $VaultName = "Logic.Monitor"

        Try {
            Get-SecretVault -Name $VaultName -ErrorAction Stop | Out-Null
            Write-Host "Existing vault $VaultName already exists, skipping creation" -ForegroundColor Yellow
        }
        Catch {
            If($_.Exception.Message -like "*Vault $VaultName does not exist in registry*") {
                Write-Host "Credential vault for cached accounts does not currently exist, creating credential vault: $VaultName" -ForegroundColor Yellow
                Register-SecretVault -Name $VaultName -ModuleName Microsoft.PowerShell.SecretStore
                Get-SecretStoreConfiguration | Out-Null
            }
        }

    }
    Process{
        #Assuming we got here we can start our session server
        Start-PodeServer {
            #Ensure we have a vault to use for storing session details
            $VaultName = "Logic.Monitor"
            $VaultKeyPrefix = "LMSessionSync"

            #Capture creds so we can use them 
            Try{
                Unlock-SecretVault -Name $VaultName -Password $(Read-Host "Enter vault credentials" -AsSecureString -OutVariable VaultCred) -ErrorAction Stop
                Set-PodeState -Name 'VaultUnlock' -Value $VaultCred | Out-Null
            }
            Catch {
                Write-Error "Unable to start SessionSync server without valid vault unlock credentials: $_"
                Return
            }

            #Rotate APIKey in vault
            $ApiKey = (1..64| ForEach-Object {[byte](Get-Random -Max 256)} | ForEach-Object ToString X2) -join ''
            Set-Secret -Name $VaultKeyPrefix-RESTAPIKey -Vault $VaultName -Secret $ApiKey -Metadata @{Modified="$(Get-Date)";Portal="SessionSync-ApiKey"}

            #Sete our web server state
            Set-PodeState -Name 'VaultName' -Value $VaultName | Out-Null
            Set-PodeState -Name 'VaultKeyPrefix' -Value $VaultKeyPrefix | Out-Null
            Set-PodeState -Name 'VaultApiKey' -Value $ApiKey | Out-Null

            Add-PodeEndpoint -Address 127.0.0.1 -Port 8072 -Protocol Http

            If($EnableRequestLogging){New-PodeLoggingMethod -Terminal | Enable-PodeRequestLogging}
            If($EnableErrorLogging){New-PodeLoggingMethod -Terminal | Enable-PodeErrorLogging}

            # setup apiKey authentication to validate a user
            New-PodeAuthScheme -ApiKey | Add-PodeAuth -Name 'Auth' -Sessionless -ScriptBlock {
                param($key)

                #Grab current key
                $ApiKey = Get-PodeState -Name 'VaultApiKey'
                
                #Check if user is authenticated
                if ($key.toString() -eq $ApiKey.toString()) {
                    return @{
                        User = @{'ID' ='1'}
                    }
                }

                # authentication failed
                return $null
            }
        
            # check the request on this route against the authentication
            Add-PodeRoute -Method Get -Path '/api/v1/portal/:AccountName' -Authentication 'Auth' -ScriptBlock {
                #Store Session Info in Secret Vault
                $VaultName = Get-PodeState -Name 'VaultName'
                $VaultKeyPrefix = Get-PodeState -Name 'VaultKeyPrefix'
                $VaultUnlock = Get-PodeState -Name 'VaultUnlock'

                Unlock-SecretVault -Name  $VaultName -Password $VaultUnlock

                #Get Session details in vault, return response data
                $AccountName = $WebEvent.Parameters['AccountName']
                Try{
                    $SecretData = Get-Secret -Name $VaultKeyPrefix-$AccountName -Vault  $VaultName -AsPlainText -ErrorAction Stop
                    Write-PodeJsonResponse -Value $SecretData
                }
                Catch{
                    Write-PodeTextResponse -Value "Unexpected error: $($_.Exception.Message)" -StatusCode 500
                    #Set-PodeResponseStatus -Code 500 -Exception "Unexpected error: $($_.Exception.Message)" -NoErrorPage
                }
            }
        
            # this route will not be validated against the authentication
            Add-PodeRoute -Method Post -Path '/api/v1/portal/:AccountName' -ScriptBlock {
                #Store Session Info in Secret Vault
                $VaultName = Get-PodeState -Name 'VaultName'
                $VaultKeyPrefix = Get-PodeState -Name 'VaultKeyPrefix'
                $VaultUnlock = Get-PodeState -Name 'VaultUnlock'

                #Convert request data into JSON and unlock vault
                $SecretData = $($WebEvent.Data | ConvertTo-Json)
                Unlock-SecretVault -Name  $VaultName -Password $VaultUnlock

                #Add/Update Session details in vault, return response data
                $AccountName = $WebEvent.Parameters['AccountName']
                Try{
                    Set-Secret -Name $VaultKeyPrefix-$AccountName -Vault  $VaultName -Secret $SecretData -Metadata @{Modified="$(Get-Date)";Type="SessionSync";Portal=$AccountName}
                    Write-PodeJsonResponse -Value $SecretData
                }
                Catch{
                    Write-PodeTextResponse -Value "Unexpected error: $($_.Exception.Message)" -StatusCode 500
                    #Set-PodeResponseStatus -Code 500 -Exception "Unexpected error: $($_.Exception.Message)" -NoErrorPage
                }
            }

            Register-PodeEvent -Type Terminate -Name 'CleanupSessions' -ScriptBlock {
                $VaultName = Get-PodeState -Name 'VaultName'
                $VaultKeyPrefix = Get-PodeState -Name 'VaultKeyPrefix'
                $VaultUnlock = Get-PodeState -Name 'VaultUnlock'

                Unlock-SecretVault -Name  $VaultName -Password $VaultUnlock
                $Sessions = Get-SecretInfo -Vault $VaultName | Where-Object {$_.Name -like "*$VaultKeyPrefix*"}
                Foreach ($Session in $Sessions){
                    Try{
                        Remove-Secret -Vault $VaultName -Name $Session.Name -ErrorAction Stop
                        Write-Host "Successfully cleared session details for $($Session.Metadata["Portal"])." -ForegroundColor Green
                    }
                    Catch{
                        Write-Error "Unable to clear session details for $($Session.Metadata["Portal"]): $_"
                    }
                }
                Disconnect-LMAccount
            }
        }
    }
    End{}
}