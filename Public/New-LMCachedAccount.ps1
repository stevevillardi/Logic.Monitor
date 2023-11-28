<#
.SYNOPSIS
Store a connection to a specified LM portal for use with Connect-LMAccount

.DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands associated with the Logic.Monitor PS module. Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

.PARAMETER AccessId
Access ID from your API credential acquired from the LM Portal

.PARAMETER AccessKey
Access Key from your API credential acquired from the LM Portal

.PARAMETER AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

.EXAMPLE
New-LMCachedAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain
#>
Function New-LMCachedAccount {

    [CmdletBinding(DefaultParameterSetName="LMv1")]
    Param (
        [Parameter(Mandatory, ParameterSetName="LMv1")]
        [String]$AccessId,

        [Parameter(Mandatory, ParameterSetName="LMv1")]
        [String]$AccessKey,

        [Parameter(Mandatory, ParameterSetName="LMv1")]
        [Parameter(Mandatory, ParameterSetName="Bearer")]
        [String]$AccountName,

        [Parameter(Mandatory, ParameterSetName="Bearer")]
        [String]$BearerToken,

        [String]$CachedAccountName = $AccountName,

        [Boolean]$OverwriteExisting = $false
    )

    Try {
        $ExistingVault = Get-SecretInfo -Name Logic.Monitor -WarningAction Stop
        Write-Host "[INFO]: Existing vault Logic.Monitor already exists, skipping creation"
    }
    Catch {
        If($_.Exception.Message -like "*There are currently no extension vaults registered*") {
            Write-Host "[INFO]: Credential vault for cached accounts does not currently exist, creating credential vault: Logic.Monitor"
            Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore
            Get-SecretStoreConfiguration | Out-Null
        }
    }

    $CurrentDate = Get-Date
    #Convert to secure string
    If($BearerToken){
        $Secret = $BearerToken | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
        [Hashtable]$Metadata = @{
            Portal      = [String]$AccountName
            Id          = "$($BearerToken.Substring(0,20))****"
            Modified    = [DateTime]$CurrentDate
            Type    = "Bearer"
        }
    }
    Else{
        $Secret = $AccessKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
        [Hashtable]$Metadata = @{
            Portal      = [String]$AccountName
            Id          = [String]$AccessId
            Modified    = [DateTime]$CurrentDate
            Type    = "LMv1"
        }
    }
    Try{
        Set-Secret -Name $CachedAccountName -Secret $Secret -Vault Logic.Monitor -Metadata $Metadata -NoClobber:$(!$OverwriteExisting)
        Write-Host "[INFO]: Successfully created cached account ($CachedAccountName) secret for portal: $AccountName"
    }
    Catch{
        Write-Error $_.Exception.Message
    }

    Return
}