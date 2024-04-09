<#
.SYNOPSIS
Function to write debug information.

.DESCRIPTION
The Resolve-LMDebugInfo function is used to write debug information to the console. It displays the invoked command, bound parameters, invoked URL, request payload, and request headers.

.PARAMETER Url
The URL that was invoked.

.PARAMETER Headers
The headers used in the request.

.PARAMETER Command
The command that was invoked.

.PARAMETER Payload
The payload used in the request.

.EXAMPLE
Resolve-LMDebugInfo -Url "https://example.com/api" -Headers @{ "Authorization" = "Bearer token" } -Command Get-LMDevice -Payload "{'key': 'value'}"
#>

Function Resolve-LMDebugInfo {
    [CmdletBinding()]
    Param (
        $Url,
        $Headers,
        $Command,
        $Payload
    )

    Write-Debug "Invoked Command: $($Command.MyCommand)"
    Write-Debug "Bound Parameters: $($Command.BoundParameters.GetEnumerator() | ForEach-Object {"[" + $($_.Key) + ":" + $($_.Value) + "]"})"
    Write-Debug "Invoked URL: $Url"
    If($Payload){Write-Debug "Request Payload: `n$Payload"}
    Write-Debug "Request Headers: $($Headers.GetEnumerator() | ForEach-Object {"[" + $($_.Key) + ":" + $(if ($_.Value.length -gt 25) { $_.Value.substring(0, 25) + "...]" } else { $($_.Value) + "]" })})"
}