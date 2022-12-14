<#
.SYNOPSIS
Connect to a specified LM portal to run commands against

.DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands associated with the Logic.Monitor PS module. Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

.PARAMETER AccessId
Access ID from your API credential acquired from the LM Portal

.PARAMETER AccessKey
Access Key from your API credential acquired from the LM Portal

.PARAMETER AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

.PARAMETER UseCachedCredential
This will list all cached account for you to pick from. This parameter is optional

.PARAMETER CachedAccountName
Name of cached account you wish to connect to. This parameter is optional and can be used in place of UseCachedCredential

.PARAMETER DisableConsoleLogging
Disables on stdout messages from displaying for any subsequent commands are run. Useful when building scripted logicmodules and you want to suppress unwanted output. Console logging is enabled by default.

.EXAMPLE
Connect-LMAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain

.EXAMPLE
Connect-LMAccount -UseCachedCredential

.NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>
Function Connect-LMAccount {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Manual')]
        [String]$AccessId,

        [Parameter(Mandatory, ParameterSetName = 'Manual')]
        [String]$AccessKey,

        [Parameter(Mandatory, ParameterSetName = 'Manual')]
        [String]$AccountName,

        [Parameter(ParameterSetName = 'Cached')]
        [Switch]$UseCachedCredential,

        [Parameter(ParameterSetName = 'Cached')]
        [String]$CachedAccountName,

        [Switch]$DisableConsoleLogging
    )

    If ($UseCachedCredential -or $CachedAccountName) {

        #Autoload web assembly if on older version of powershell
        If((Get-Host).Version.Major -lt 6){
            Add-type -AssemblyName System.Web
        }

        Try {
            $ExistingVault = Get-SecretInfo -Name Logic.Monitor -WarningAction Stop
            Write-Host "Existing vault Logic.Monitor already exists, skipping creation" -ForegroundColor Yellow
        }
        Catch {
            If($_.Exception.Message -like "*There are currently no extension vaults registered*") {
                Write-Host "Credential vault for cached accounts does not currently exist, creating credential vault: Logic.Monitor" -ForegroundColor Yellow
                Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore
                Get-SecretStoreConfiguration | Out-Null
            }
        }
        $CredentialPath = Join-Path -Path $Home -ChildPath "Logic.Monitor.json"
        If ((Test-Path -Path $CredentialPath)) {
            Write-Host "Previous version of cached accounts detected, migrating to secret store..." -ForegroundColor Yellow
            $CredentialFile = Get-Content -Path $CredentialPath | ConvertFrom-Json | Sort-Object -Property Modified -Descending
            $MigrationComplete = $true
            Foreach ($Credential in $CredentialFile) {
                $CurrentDate = Get-Date
                [Hashtable]$Metadata = @{
                    Portal      = [String]$Credential.Portal
                    Id          = [String]$Credential.Id
                    Modified    = [DateTime]$CurrentDate
                }
                Try{
                    Set-Secret -Name $Credential.Portal -Secret $Credential.Key -Vault Logic.Monitor -Metadata $Metadata -NoClobber
                    Write-Host "Successfully migrated cached account secret for portal: $($Credential.Portal)" -ForegroundColor Yellow
                }
                Catch{
                    Write-Error $_.Exception.Message
                    $MigrationComplete = $false
                }
            }
            If($MigrationComplete){
                Remove-Item -Path $CredentialPath -Confirm:$false
                Write-Host "Successfully migrated cached accounts into secret store, your legacy account cache hes been removed." -ForegroundColor Yellow
            }
            Else{
                $NewName = Join-Path -Path $Home -ChildPath "Logic.Monitor-Migrated.json"
                Rename-Item -Path $CredentialPath -Confirm:$false -NewName $NewName
                Write-Host "Unable to fully migrate cached accounts into secret store, your legacy account cache has been archived at: $NewName. No other attemps will be made to migrate any failed accounts." -ForegroundColor Red
            }
        }

        If($CachedAccountName){
            #If supplied and account name just use that vs showing a list of accounts
            $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
            $CachedAccountIndex = $CachedAccountSecrets.Name.IndexOf($CachedAccountName)
            If($CachedAccountIndex -ne -1){
                $AccountName = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Portal"]
                [SecureString]$AccessKey = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                $AccessId = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Id"]
            }
            Else{
                Write-Error "Entered CachedAccountName ($CachedAccountName) does not match one of the stored credentials, please check the selected entry and try again"
                Return
            }
        }
        Else{
            #List out current portals with saved credentials and let users chose which to use
            $i = 0
            $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
            If($CachedAccountSecrets){
                Write-Host "Selection Number | Portal Name"
                Foreach ($Credential in $CachedAccountSecrets) {
                    Write-Host "$i)     $($Credential.Name)"
                    $i++
                }
                $StoredCredentialIndex = Read-Host -Prompt "Enter the number for the cached credential you wish to use"
                If ($CachedAccountSecrets[$StoredCredentialIndex]) {
                    $AccountName = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Portal"]
                    [SecureString]$AccessKey = Get-Secret -Vault "Logic.Monitor" -Name $AccountName -AsPlainText | ConvertTo-SecureString
                    $AccessId = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Id"]
                }
                Else {
                    Write-Error "Entered value does not match one of the listed credentials, please check the selected entry and try again"
                    Return
                }
            }
            Else{
                Write-Error "No entries currently found in secret vault Logic.Monitor"
                    Return
            }
        }
    }
    Else {
        #Convert to secure string
        [SecureString]$AccessKey = $AccessKey | ConvertTo-SecureString -AsPlainText -Force
    }
    
    #Create Credential Object for reuse in other functions
    $Script:LMAuth = [PSCustomObject]@{
        Id     = $AccessId
        Key    = $AccessKey
        Portal = $AccountName
        Valid  = $false
        Logging = !$DisableConsoleLogging.IsPresent
    }

    #Check for newer version of Logic.Monitor module
    Update-LogicMonitorModule -CheckOnly

    Try {
        #Set valid flag so we dont prompt for auth details on future requests
        $Script:LMAuth.Valid = $true

        #Collect portal info and api username and roles
        $ApiInfo = Get-LMAPIToken -Filter @{accessId = $AccessId } -ErrorAction SilentlyContinue
        If ($ApiInfo) {
            $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
            Write-LMHost "Connected to LM portal $($PortalInfo.companyDisplayName) using account $($ApiInfo.adminName) with assigned roles: $($ApiInfo.roles -join ",") - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)." -ForegroundColor Green
            Return
        }
        Else {
            Try{
                $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
                Write-LMHost "Connected to LM portal $($PortalInfo.companyDisplayName) using access id $AccessId - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)." -ForegroundColor Green
                Return
            }
            Catch {
                throw "Unable to validate API token info"
            }
        }
    }
    Catch {
        Try{
            $DeviceInfo = Get-LMDevice -ErrorAction Stop

            If($DeviceInfo){
                Write-LMHost "Connected to LM portal $AccountName with limited permissions, ensure your api token has the necessary rights needed to run desired commands." -ForegroundColor Yellow
                Return
            }
            Else{
                throw "Unable to verify api token permission levels, ensure api token has rights to view all/select resources or at minimum view access for Account Information"
            }
        }
        Catch{

            throw "Unable to login to account, please ensure your access info and account name are correct: $($_.Exception.Message)"
            #Clear credential object from environment
            Remove-Variable LMAuth -Scope Global -ErrorAction SilentlyContinue
        }
        Return
    }
}
