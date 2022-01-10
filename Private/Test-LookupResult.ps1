#Function to validate output when using -Name param instead of specifying Id, ensures a valid response and only one result returned
Function Test-LookupResult {
    Param (
        $Result,
    
        $LookupString
    )
    #If mutiple resources are returned stop processing
    If (($Result | Measure-Object).Count -gt 1) {
        [Console]::ForegroundColor = 'red'
        [Console]::Error.WriteLine("Mutiple resources returned for the specified name value: $LookupString. Please ensure value is unique and try again")
        [Console]::ResetColor()
        return $true
    }
    #If empty stop processing since we have no Id to use
    ElseIf (!$Result) {
        [Console]::ForegroundColor = 'red'
        [Console]::Error.WriteLine("Unable to find resource for the specified name value: $LookupString. Please check spelling and try again.")
        [Console]::ResetColor()
        return $true
    }
    return $false
}