#Function to write debug info
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
    If($Payload){Write-Debug "Request Payload: $Payload"}
    Write-Debug "Request Headers: $($Headers.GetEnumerator() | ForEach-Object {"[" + $($_.Key) + ":" + $(if ($_.Value.length -gt 25) { $_.Value.substring(0, 25) + "...]" } else { $($_.Value) + "]" })})"
}