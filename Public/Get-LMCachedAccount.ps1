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