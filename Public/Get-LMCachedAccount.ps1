<#
.SYNOPSIS
Retrieves information about cached accounts from the Logic.Monitor vault.

.DESCRIPTION
The Get-LMCachedAccount function retrieves information about cached accounts from the Logic.Monitor vault. It returns an array of custom objects containing details such as the cached account name, portal, ID, modified date, and type.

.PARAMETER CachedAccountName
Specifies the name of a specific cached account to retrieve information for. If not provided, information for all cached accounts will be returned.

.EXAMPLE
Get-LMCachedAccount -CachedAccountName "Account1"
Retrieves information for the cached account named "Account1" from the Logic.Monitor vault.

.EXAMPLE
Get-LMCachedAccount
Retrieves information for all cached accounts from the Logic.Monitor vault.

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Object[]
An array of custom objects representing the cached accounts. Each object contains the following properties:
- CachedAccountName: The name of the cached account.
- Portal: The portal associated with the cached account.
- Id: The ID of the cached account. If not available, "N/A" is displayed.
- Modified: The modified date of the cached account.
- Type: The type of the cached account. If not available, "LMv1" is displayed.

.NOTES
This function requires the Get-SecretInfo function from the Logic.Monitor vault.

.LINK
Get-SecretInfo

#>

Function Get-LMCachedAccount {
    [CmdletBinding()]
    Param (
        [String]$CachedAccountName
    )
    If($CachedAccountName){
        $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor -Name $CachedAccountName
    }
    Else{
        $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
    }
    $CachedAccounts = @()
    Foreach ($Secret in $CachedAccountSecrets){
        $CachedAccounts += [PSCustomObject]@{
            CachedAccountName      = $Secret.Name
            Portal      = $Secret.Metadata["Portal"]
            Id          = If(!$Secret.Metadata["Id"]){"N/A"}Else{$Secret.Metadata["Id"]}
            Modified    = $Secret.Metadata["Modified"]
            Type    = If(!$Secret.Metadata["Type"]){"LMv1"}Else{$Secret.Metadata["Type"]}
        }
    }
    Return $CachedAccounts

}