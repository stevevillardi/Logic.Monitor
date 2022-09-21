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

    Try {
        $ExistingVault = Get-SecretInfo -Name Logic.Monitor -WarningAction Stop
        Write-Host "Existing vault Logic.Monitor already exists, skipping creation"
    }
    Catch {
        If($_.Exception.Message -like "*There are currently no extension vaults registered*") {
            Write-Host "Credential vault for cached accounts does not currently exist, creating credential vault: Logic.Monitor"
            Register-SecretVault -Name Logic.Monitor -ModuleName Microsoft.PowerShell.SecretStore
            Get-SecretStoreConfiguration | Out-Null
        }
    }

    $CurrentDate = Get-Date
    #Convert to secure string
    $AccessKey = $AccessKey | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
    [Hashtable]$Metadata = @{
        Portal      = [String]$AccountName
        Id          = [String]$AccessId
        Modified    = [DateTime]$CurrentDate
    }
    Try{
        Set-Secret -Name $AccountName -Secret $AccessKey -Vault Logic.Monitor -Metadata $Metadata -NoClobber:$(!$OverwriteExisting)
        Write-Host "Successfully created cached account secret for portal: $AccountName"
    }
    Catch{
        Write-Error $_.Exception.Message
    }

    Return
}