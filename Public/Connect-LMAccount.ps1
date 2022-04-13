<#
.SYNOPSIS
Connect to a specified LM portal to run commands against

.DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands assoicated with the Logic.Monitor PS module. Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

.PARAMETER AccessId
Access ID from your API credential aquired from the LM Portal

.PARAMETER AccessKey
Access Key from your API credential aquired from the LM Portal

.PARAMETER AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

.PARAMETER UseCachedCredential
Used a cached account that has been added using New-LMCachedAccount instead of explicitly providing credentials.

.PARAMETER CachedAccountName
Name of cached account you wish to connect to. If none is provided a list will be presented to pick from. This parameter is optional.

.PARAMETER DisableConsoleLogging
Disables on stdout messages from displaying for any subsquent commands are run. Useful when building scripted logicmodules and you want to supress unwanted output. Console logging is enabled by default.

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

        [Parameter(Mandatory, ParameterSetName = 'Cached')]
        [Switch]$UseCachedCredential,

        [Parameter(ParameterSetName = 'Cached')]
        [String]$CachedAccountName,

        [Switch]$DisableConsoleLogging
    )
    If ($UseCachedCredential) {
        $CredentialPath = Join-Path -Path $Home -ChildPath "Logic.Monitor.json"
        If ((Test-Path -Path $CredentialPath)) {
            $CredentialFile = Get-Content -Path $CredentialPath | ConvertFrom-Json | Sort-Object -Property Modified -Descending

            #If supplied and account name just use that vs showing a list of accounts
            If($CachedAccountName){
                $CachedAccountIndex = $CredentialFile.portal.IndexOf($CachedAccountName)
                If($CachedAccountIndex -ne -1){
                    $AccountName = $CredentialFile[$CachedAccountIndex].Portal
                    [SecureString]$AccessKey = $CredentialFile[$CachedAccountIndex].Key | ConvertTo-SecureString
                    $AccessId = $CredentialFile[$CachedAccountIndex].Id
                }
                Else{
                    Write-Error "Entered CachedAccountName ($CachedAccountName) does not match one of the stored credentials, please check the selected entry and try again"
                    Return
                }

            }
            Else{
                #List out current portals with saved credentials and let users chose which to use
                $i = 0
                Write-Host "Selection Number | Portal Name"
                Foreach ($Credential in $CredentialFile) {
                    Write-Host "$i)     $($Credential.Portal)"
                    $i++
                }
                $StoredCredentialIndex = Read-Host -Prompt "Enter the number for the cached credential you wish to use"
                If ($CredentialFile[$StoredCredentialIndex]) {
                    $AccountName = $CredentialFile[$StoredCredentialIndex].Portal
                    [SecureString]$AccessKey = $CredentialFile[$StoredCredentialIndex].Key | ConvertTo-SecureString
                    $AccessId = $CredentialFile[$StoredCredentialIndex].Id
                }
                Else {
                    Write-Error "Entered value does not match one of the listed credentials, please check the selected entry and try again"
                    Return
                }
            }
        }
        Else {
            Write-Error "No credential file could be located, use New-LMCachedAccount to cache a credential for use with -CachedAccountName or manually specify api credentials"
            Return
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

    Try {
        #Set valid flag so we dont prompt for auth details on future requests
        $Script:LMAuth.Valid = $true

        #Collect portal info and api username and roles
        $ApiInfo = Get-LMAPIToken -Filter @{accessId = $AccessId } -ErrorAction Stop
        If ($ApiInfo) {
            $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
            
            Write-LMHost "Connected to LM portal $($PortalInfo.companyDisplayName) using account $($ApiInfo.adminName) with assgined roles: $($ApiInfo.roles -join ",") - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)." -ForegroundColor Green
            
            Return
        }
        Else {
            throw "Unable to get API token info"
        }
    }
    Catch {
        Write-Error "Unable to login to account, please ensure your access info and account name are correct: $($_.Exception.Message)"
        #Clear credential object from environment
        Remove-Variable LMAuth -Scope Global -ErrorAction SilentlyContinue
        Return
    }
}
