<#
.SYNOPSIS
Disconnect from a previouslly connected LM portal

.DESCRIPTION
Clears stored API credentials for a previously connected LM portal. Useful for switching between LM portals or clearing credentials after a script runs

.EXAMPLE
Disconnect-LMAccount

.NOTES
Once disconnect you will need to reconnect to a portal before you will be allowed to run commands again.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>
Function Disconnect-LMAccount {
    #Clear credential object from environment
    If (Get-Variable -Name LMAuth -Scope Global -ErrorAction SilentlyContinue) {
        Remove-Variable LMAuth -Scope Global -ErrorAction SilentlyContinue
        Write-Host "Successfully cleared login credentials for LM account." -ForegroundColor Green
    }
    Else {
        Write-Host "Not currently connected to any LM account."
    }
}
