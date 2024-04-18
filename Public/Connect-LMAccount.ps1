<#
.SYNOPSIS
Connect to a specified LM portal to run commands against

.DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands associated with the Logic.Monitor PS module. Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

.PARAMETER AccessId
Access ID from your API credential acquired from the LM Portal

.PARAMETER AccessKey
Access Key from your API credential acquired from the LM Portal

.PARAMETER BearerToken
Bearer token from your API credential acquired from the LM Portal. For use in place of LMv1 token

.PARAMETER AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

.PARAMETER UseCachedCredential
This will list all cached account for you to pick from. This parameter is optional

.PARAMETER CachedAccountName
Name of cached account you wish to connect to. This parameter is optional and can be used in place of UseCachedCredential

.PARAMETER SessionSync
Use session sync capability instead of api key

.PARAMETER DisableConsoleLogging
Disables on stdout messages from displaying for any subsequent commands are run. Useful when building scripted logicmodules and you want to suppress unwanted output. Console logging is enabled by default.

.EXAMPLE
Connect-LMAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain

.EXAMPLE
Connect-LMAccount -BearerToken xxxxxx -AccountName subdomain

.EXAMPLE
Connect-LMAccount -UseCachedCredential

.NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/logicmonitor/lm-powershell-module

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>
Function Connect-LMAccount {

    [CmdletBinding(DefaultParameterSetName="LMv1")]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'LMv1')]
        [String]$AccessId,

        [Parameter(Mandatory, ParameterSetName = 'LMv1')]
        [String]$AccessKey,

        [Parameter(Mandatory, ParameterSetName = 'Bearer')]
        [String]$BearerToken,

        [Parameter(Mandatory, ParameterSetName = 'LMv1')]
        [Parameter(Mandatory, ParameterSetName = 'Bearer')]
        [Parameter(Mandatory, ParameterSetName = 'SessionSync')]
        [String]$AccountName,

        [Parameter(ParameterSetName = 'Cached')]
        [Switch]$UseCachedCredential,

        [Parameter(ParameterSetName = 'Cached')]
        [String]$CachedAccountName,

        [Parameter(ParameterSetName = 'SessionSync')]
        [Switch]$SessionSync,

        [Switch]$AutoUpdateModuleVersion,

        [Switch]$DisableConsoleLogging,

        [Switch]$SkipVersionCheck,

        [Switch]$SkipCredValidation
    )

    #Autoload web assembly if on older version of powershell
    If((Get-Host).Version.Major -lt 6){
        Add-type -AssemblyName System.Web
    }

    If ($UseCachedCredential -or $CachedAccountName) {

        Try {
            $ExistingVault = Get-SecretVault -Name Logic.Monitor -ErrorAction Stop
            Write-Host "[INFO]: Existing vault Logic.Monitor already exists, skipping creation"
        }
        Catch {
            If($_.Exception.Message -like "*Vault Logic.Monitor does not exist in registry*") {
                Write-Host "[INFO]: Credential vault for cached accounts does not currently exist, creating credential vault: Logic.Monitor" 
                Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore
                Get-SecretStoreConfiguration | Out-Null
            }
        }
        $CredentialPath = Join-Path -Path $Home -ChildPath "Logic.Monitor.json"
        If ((Test-Path -Path $CredentialPath)) {
            Write-Host "[INFO]: Previous version of cached accounts detected, migrating to secret store..." 
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
                    Write-Host "[INFO]: Successfully migrated cached account secret for portal: $($Credential.Portal)"
                }
                Catch{
                    Write-Error $_.Exception.Message
                    $MigrationComplete = $false
                }
            }
            If($MigrationComplete){
                Remove-Item -Path $CredentialPath -Confirm:$false
                Write-Host "[INFO]: Successfully migrated cached accounts into secret store, your legacy account cache hes been removed."
            }
            Else{
                $NewName = Join-Path -Path $Home -ChildPath "Logic.Monitor-Migrated.json"
                Rename-Item -Path $CredentialPath -Confirm:$false -NewName $NewName
                Write-Host "[ERROR]: Unable to fully migrate cached accounts into secret store, your legacy account cache has been archived at: $NewName. No other attemps will be made to migrate any failed accounts." -ForegroundColor Red
            }
        }

        If($CachedAccountName){
            #If supplied and account name just use that vs showing a list of accounts
            $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
            $CachedAccountIndex = $CachedAccountSecrets.Name.IndexOf($CachedAccountName)
            If($CachedAccountIndex -ne -1){
                $AccountName = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Portal"]
                $AccessId = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Id"]
                $Type = $CachedAccountSecrets[$CachedAccountIndex].Metadata["Type"]
                If(($Type -eq "LMv1") -or ($null -eq $Type)){
                    [SecureString]$AccessKey = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                }
                Else{
                    [SecureString]$BearerToken = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                }
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
                    If($Credential.Name -notlike "*LMSessionSync*"){
                        Write-Host "$i)     $($Credential.Name)"
                    }
                    $i++
                }
                $StoredCredentialIndex = Read-Host -Prompt "Enter the number for the cached credential you wish to use"
                If ($CachedAccountSecrets[$StoredCredentialIndex]) {
                    $AccountName = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Portal"]
                    $CachedAccountName = $CachedAccountSecrets[$StoredCredentialIndex].Name
                    $AccessId = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Id"]
                    $Type = $CachedAccountSecrets[$StoredCredentialIndex].Metadata["Type"]
                    If($Type -eq "LMv1"){
                        [SecureString]$AccessKey = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                    }
                    ElseIf($Type -eq "Bearer"){
                        [SecureString]$BearerToken = Get-Secret -Vault "Logic.Monitor" -Name $CachedAccountName -AsPlainText | ConvertTo-SecureString
                    }
                    Else{
                        Write-Error "Invalid credential type detected for selection: $Type"
                        Return
                    }
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
        If($PsCmdlet.ParameterSetName -eq "LMv1"){
            #Convert to secure string
            [SecureString]$AccessKey = $AccessKey | ConvertTo-SecureString -AsPlainText -Force
            $Type = "LMv1"
        }
        ElseIf($PsCmdlet.ParameterSetName -eq "SessionSync"){
            $Session = Get-LMSession -AccountName $AccountName
            If($Session){
                $AccessId     = $Session.jSessionID #Session Id
                $AccessKey    = $Session.token #CSRF Token
                $Type = "SessionSync"
            }
            Else{
                throw "Unable to validate session sync info for: $AccountName"
            }
        }
        Else{
            #Convert to secure string
            [SecureString]$BearerToken = $BearerToken | ConvertTo-SecureString -AsPlainText -Force
            $Type = "Bearer"
        }
    }

    If(!$Type){
        $Type = "LMv1"
    }
    
    #Create Credential Object for reuse in other functions
    $Script:LMAuth = [PSCustomObject]@{
        Id     = $AccessId
        Key    = $AccessKey
        BearerToken    = $BearerToken
        Portal = $AccountName
        Valid  = $true
        Logging = !$DisableConsoleLogging.IsPresent
        Type = $Type
    }
    
    #Check for newer version of Logic.Monitor module
    Try{
        If($AutoUpdateModuleVersion -and !$SkipVersionCheck){
            Update-LogicMonitorModule
        }
        ElseIf(!$SkipVersionCheck){
            Update-LogicMonitorModule -CheckOnly
        }
    }
    Catch{
        Write-Host "[ERROR]: Unable to check for newer version of Logic.Monitor module: $($_.Exception.Message)" -ForegroundColor Red
    }

    If(!$SkipCredValidation){
        Try {
            #Collect portal info and api username and roles
            If($Type -eq "Bearer"){
                $Token = [System.Net.NetworkCredential]::new("", $BearerToken).Password
                $ApiInfo = Get-LMAPIToken -Type Bearer -ErrorAction SilentlyContinue | Where-Object {$_.accessKey -like "$($Token.Substring(0,20))*"}
            }
            Else{
                $ApiInfo = Get-LMAPIToken -Filter "accessId -eq '$AccessId'" -ErrorAction SilentlyContinue
            }
    
            If ($ApiInfo) {
                $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
                Write-LMHost "[INFO]: Connected to LM portal $($PortalInfo.companyDisplayName) using account ($($ApiInfo.adminName) via $Type Token) with assigned roles: $($ApiInfo.roles -join ",") - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)." -ForegroundColor Green
                Return
            }
            Else {
                Try{
                    $PortalInfo = Get-LMPortalInfo -ErrorAction Stop
                    Write-LMHost "[INFO]: Connected to LM portal $($PortalInfo.companyDisplayName) via $Type Token - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)." -ForegroundColor Green
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
                    Write-LMHost "[INFO]: Connected to LM portal $AccountName via $Type Token with limited permissions, ensure your api token has the necessary rights needed to run desired commands." -ForegroundColor Yellow
                    Return
                }
                Else{
                    throw "Unable to verify api token permission levels, ensure api token has rights to view all/select resources or at minimum view access for Account Information"
                }
            }
            Catch{
    
                #Clear credential object from environment
                Remove-Variable LMAuth -Scope Script -ErrorAction SilentlyContinue
                throw "Unable to login to account, please ensure your access info and account name are correct: $($_.Exception.Message)"
            }
            Return
        }
    }
    Else{
        Write-LMHost "[INFO]: Skipping validation of credentials, connected to LM portal $AccountName via $Type, ensure your api token has the necessary rights needed to run desired commands." -ForegroundColor Yellow
    }
}
