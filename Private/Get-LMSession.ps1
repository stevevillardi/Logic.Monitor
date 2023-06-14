Function Get-LMSession {
    Param (
        [String]$AccountName
    )

    $VaultName = "Logic.Monitor"
    $VaultKeyPrefix = "LMSessionSync"

    Try{
        $ApiKey = Get-Secret -Name $VaultKeyPrefix-RESTAPIKey -Vault  $VaultName -AsPlainText -ErrorAction Stop
        $Response = Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:8072/api/v1/portal/$AccountName" -Headers @{"X-API-Key"=$ApiKey}

        Return $Response
    }
    Catch {
        throw "Error retrieving session details: $_"
    }
}