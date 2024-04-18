<#
.SYNOPSIS
Retrieves the status of the LogicMonitor account.

.DESCRIPTION
The Get-LMAccountStatus function is used to retrieve the status of the LogicMonitor account. It checks if the user is currently logged into any LogicMonitor portals and returns the account status.

.PARAMETER None
This function does not accept any parameters.

.EXAMPLE
Get-LMAccountStatus

This example demonstrates how to use the Get-LMAccountStatus function to retrieve the status of the LogicMonitor account.

.OUTPUTS
[System.Management.Automation.PSCustomObject]
The function returns a custom object with the following properties:
- Portal: The LogicMonitor portal URL.
- Valid: Indicates if the user is currently logged into a LogicMonitor portal.
- Logging: Indicates if logging is enabled for the LogicMonitor account.
- Type: The type of authentication used for the LogicMonitor account.
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
