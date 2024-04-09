<#
.SYNOPSIS
    Function to validate output when using -Name param instead of specifying Id, ensures a valid response and only one result returned.

.DESCRIPTION
    The Test-LookupResult function is used to validate the output when using the -Name parameter instead of specifying the Id. It ensures that a valid response is received and only one result is returned.

.PARAMETER Result
    The Result parameter represents the output of the lookup operation.

.PARAMETER LookupString
    The LookupString parameter represents the value used for the lookup operation.

.EXAMPLE
    Test-LookupResult -Result $result -LookupString "example"
#>

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