#Function to validate output when using -Name param instead of specifying Id, ensures a valid response and on one result returned
Function Test-LookupResult {
    Param (
        $Result,
    
        [String]$LookupString
    )
    #If mutiple resources are returned stop processing
    If (($Result | Measure-Object).Count -gt 1) {
        Write-Host "Mutiple resources returned for the specified name value: $LookupString. Please ensure value is unique and try again" -ForegroundColor Yellow
        return $true
    }
    #If empty stop processing since we have no Id to use
    ElseIf (!$Result) {
        Write-Host "Unable to find resource for the specified name value: $LookupString. Please check spelling and try again." -ForegroundColor Yellow
        return $true
    }
    return $false
}