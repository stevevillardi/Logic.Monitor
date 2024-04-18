<#
.SYNOPSIS
Removes cached account information from the Logic.Monitor vault.

.DESCRIPTION
The Remove-LMCachedAccount function is used to remove cached account information from the Logic.Monitor vault. It provides two parameter sets: 'Single' and 'All'. When using the 'Single' parameter set, you can specify a single cached account to remove. When using the 'All' parameter set, all cached accounts will be removed.

.PARAMETER CachedAccountName
Specifies the name of the cached account to remove. This parameter is used with the 'Single' parameter set.

.PARAMETER RemoveAllEntries
Indicates that all cached accounts should be removed. This parameter is used with the 'All' parameter set.

.EXAMPLE
Remove-LMCachedAccount -CachedAccountName "JohnDoe"
Removes the cached account with the name "JohnDoe" from the Logic.Monitor vault.

.INPUTS
You can pipe objects to this function.

.EXAMPLE
Remove-LMCachedAccount -RemoveAllEntries
Removes all cached accounts from the Logic.Monitor vault.
#>

Function Remove-LMCachedAccount {
    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Single', ValueFromPipelineByPropertyName)]
        [Alias("Portal")]
        [String]$CachedAccountName,

        [Parameter(ParameterSetName = 'All')]
        [Switch]$RemoveAllEntries
    )
    Begin{}
    Process{
        If($RemoveAllEntries){
            $CachedAccounts = Get-SecretInfo -Vault Logic.Monitor
            if ($PSCmdlet.ShouldProcess("$(($CachedAccounts | Measure-Object).Count) cached account(s)", "Remove All Cached Accounts")) {                
                Foreach ($Account in $CachedAccounts.Name){
                    Try{
                        Remove-Secret -Name $Account -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                        Write-Host "[INFO]: Removed cached account secret for: $Account"
                    }
                    Catch{
                        Write-Error $_.Exception.Message
                    }
                }
                Write-Host "[INFO]: Processed all entries from credential cache"
            }
        }
        Else{
            If ($PSCmdlet.ShouldProcess($CachedAccountName, "Remove Cached Account")) {                
                Try{
                    Remove-Secret -Name $CachedAccountName -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                    Write-Host "[INFO]: Removed cached account secret for: $CachedAccountName"
                }
                Catch{
                    Write-Error $_.Exception.Message
                }
            }
        }
    }
    End{}
}