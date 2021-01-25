Function Disconnect-LMAccount
{
    #Clear credential object from environment
    Remove-Variable LMAuth -Scope Global
    Write-Host "Successfully cleared login credentials for LM account." -ForegroundColor Green
}
