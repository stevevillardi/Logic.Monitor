Function Get-LMCachedAccount {

    #Constuct cred path universally for windows and linux/mac
    $CredentialPath = Join-Path -Path $Home -ChildPath "Logic.Monitor.json"

    If (Test-Path -Path $CredentialPath) {
        Get-Content -Path $CredentialPath | ConvertFrom-Json
    }
    Else {
        Write-Error "No credential file found, use Import-LMCachedAccount to setup a cached credential file"
    }
}