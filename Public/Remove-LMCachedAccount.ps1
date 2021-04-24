Function Remove-LMCachedAccount {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Single')]
        [String]$AccountName,

        [Parameter(ParameterSetName = 'All')]
        [Boolean]$RemoveAllEntries = $false
    )

    #Constuct cred path universally for windows and linux/mac
    $CredentialPath = Join-Path -Path $Home -ChildPath "Logic.Monitor.json"

    If (Test-Path -Path $CredentialPath) {
        If ($RemoveAllEntries) {
            $null | Set-Content -Path $CredentialPath
            Write-Host "Removed all entries from credential file"
        }
        Else {
            $CredentialFile = Get-Content -Path $CredentialPath | ConvertFrom-Json
            $CredentialIndex = $CredentialFile.Portal.IndexOf($AccountName)
            If ($CredentialIndex -ne -1) {
                If (($CredentialFile | Measure-Object).Count -eq 1) {
                    $null | Set-Content -Path $CredentialPath
                }
                Else {
                    $CredentialFile | Where-Object { $_.Portal -notin $AccountName } | ConvertTo-Json | Set-Content -Path $CredentialPath
                }
                Write-Host "Removed $AccountName from credential file"
            }
            Else {
                Write-Host "No cached entry found for $AccountName in credential file" -ForegroundColor Yellow
            }
        }
    }
    Else {
        Write-Host "No credential file found, use Import-LMCachedAccount to setup a cached credential file" -ForegroundColor Yelow
    }
}