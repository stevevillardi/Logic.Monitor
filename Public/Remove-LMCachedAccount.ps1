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