<#
.SYNOPSIS
Disconnect from a previouslly connected LM portal

.DESCRIPTION
Clears stored API credentials for a previously connected LM portal. Useful for switching between LM portals or clearing credentials after a script runs

.EXAMPLE
Disconnect-LMAccount

.NOTES
Once disconnect you will need to reconnect to a portal before you will be allowed to run commands again.
#>
Function Disconnect-LMAccount {
    #Clear credential object from environment
    Remove-Variable LMAuth -Scope Global
    Write-Host "Successfully cleared login credentials for LM account." -ForegroundColor Green
}
