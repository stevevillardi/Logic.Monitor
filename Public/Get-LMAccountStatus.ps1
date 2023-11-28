<#
.SYNOPSIS
Disconnect from a previously connected LM portal

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
Function Get-LMAccountStatus {
    #Clear credential object from environment
    If ($Script:LMAuth) {
        $Result = [PSCustomObject]@{
            Portal = $Script:LMAuth.Portal
            Valid = $Script:LMAuth.Valid
            Logging = $Script:LMAuth.Logging
            Type = $Script:LMAuth.Type
        }
        return $Result
    }
    Else {
        return "Not currently logged into any LogicMonitor portals."
    }
}
