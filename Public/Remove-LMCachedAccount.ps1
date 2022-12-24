Function Remove-LMCachedAccount {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Single', ValueFromPipelineByPropertyName)]
        [Alias("Portal")]
        [String]$CachedAccountName,

        [Parameter(ParameterSetName = 'All')]
        [Boolean]$RemoveAllEntries = $false
    )
    Begin{}
    Process{
        If($RemoveAllEntries){
            $CachedAccounts = Get-SecretInfo -Vault Logic.Monitor
    
            Foreach ($Account in $CachedAccounts.Name){
                Try{
                    Remove-Secret -Name $Account -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                    Write-Host "Removed cached account secret for: $Account"
                }
                Catch{
                    Write-Error $_.Exception.Message
                }
            }
            Write-Host "Processed all entries from credential cache"
        }
        Else{
            Try{
                Remove-Secret -Name $CachedAccountName -Vault Logic.Monitor -Confirm:$false -ErrorAction Stop
                Write-Host "Removed cached account secret for: $CachedAccountName"
            }
            Catch{
                Write-Error $_.Exception.Message
            }
        }
    }
    End{}
}