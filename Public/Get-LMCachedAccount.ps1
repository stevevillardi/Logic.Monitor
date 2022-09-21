Function Get-LMCachedAccount {
    [CmdletBinding()]
    Param (
        [String]$AccountName
    )
    If($AccountName){
        $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor -Name $AccountName
    }
    Else{
        $CachedAccountSecrets = Get-SecretInfo -Vault Logic.Monitor
    }
    $CachedAccounts = @()
    Foreach ($Secret in $CachedAccountSecrets.Metadata){
        $CachedAccounts += [PSCustomObject]@{
            Portal      = $Secret["Portal"]
            Id          = $Secret["Id"]
            Modified    = $Secret["Modified"]
        }
    }
    Return $CachedAccounts

}