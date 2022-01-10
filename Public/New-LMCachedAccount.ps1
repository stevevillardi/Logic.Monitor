<#
.SYNOPSIS
Store a connection to a specified LM portal for use with Connect-LMAccount

.DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands assoicated with the Logic.Monitor PS module. Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

.PARAMETER AccessId
Access ID from your API credential aquired from the LM Portal

.PARAMETER AccessKey
Access Key from your API credential aquired from the LM Portal

.PARAMETER AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

.EXAMPLE
New-LMCachedAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain
#>
Function New-LMCachedAccount {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$AccessId,

        [Parameter(Mandatory)]
        [String]$AccessKey,

        [Parameter(Mandatory)]
        [String]$AccountName,

        [Boolean]$OverwriteExisting = $false
    )
    #Constuct cred path universally for windows and linux/mac
    $CredentialPath = Join-Path -Path $Home -ChildPath "Logic.Monitor.json"

    
    Try {
        #Connect-LMAccount -AccessId $AccessId -AccessKey $AccessKey -AccountName $AccountName
        $CurrentDate = Get-Date
        #Convert to secure string
        $AccessKey = $AccessKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
    
        #Create Credential Object
        $AccountCredentials = @()
        $AccountCredentials += [PSCustomObject]@{
            Portal   = $AccountName
            Id       = $AccessId
            Key      = $AccessKey
            Modified = $CurrentDate
        }
        #Check to see if we have a credential file saved already
        If (!(Test-Path -Path $CredentialPath)) {
            #First time storing credentials
            New-Item -ItemType File -Path $CredentialPath | Out-Null
            $AccountCredentials
            $AccountCredentials | ConvertTo-Json | Set-Content -Path $CredentialPath
            Write-LMHost "Credential for $AccountName has been saved to: $CredentialPath"
        }
        Else {
            $CredentialFile = Get-Content -Path $CredentialPath | ConvertFrom-Json

            #Check if credential already exists
            If (!($CredentialFile.Portal -match $AccountName)) {
                #Loop through credentials and add to new array
                Foreach ($Cred in $CredentialFile) {
                    $AccountCredentials += [PSCustomObject]@{
                        Portal   = $Cred.Portal
                        Id       = $Cred.Id
                        Key      = $Cred.Key
                        Modified = $Cred.Modified
                    }
                }
                #Export new credentials for json file
                $AccountCredentials
                $AccountCredentials | ConvertTo-Json | Set-Content -Path $CredentialPath
                Write-LMHost "Credential for $AccountName has been saved to: $CredentialPath"
            }
            Else {
                If ($OverwriteExisting) {
                    $ExistingCred = $CredentialFile.Portal.IndexOf("$AccountName")

                    $CredentialFile[$ExistingCred].Id = $AccessId
                    $CredentialFile[$ExistingCred].Key = $AccessKey
                    $CredentialFile[$ExistingCred].Portal = $AccountName
                    $CredentialFile[$ExistingCred].Modified = $CurrentDate

                    #Export new credentials for json file
                    $CredentialFile
                    $CredentialFile | ConvertTo-Json | Set-Content -Path $CredentialPath
                    Write-LMHost "Credential for $AccountName has been updated in: $CredentialPath"
                }
                Else {
                    Write-LMHost "A credential for portal $AccountName already exists, use overwrite switch to update existing entry"
                }
            }
        }
    }
    Catch {
        Write-Error "Unable to store credentials, check that you have the correct api info and try again"
    }
}