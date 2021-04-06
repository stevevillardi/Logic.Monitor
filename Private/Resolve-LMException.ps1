#Function to throttle API requests exceeding limits
Function Resolve-LMException {
    Param (
        $LMException
    )
    #Add in rate limit handeling
    If ($LMException.Exception.Response.StatusCode.value__ -eq 429) {
        $RateLimitWindow = $LMException.Exception.Response.Headers.Value[$LMException.Exception.Response.Headers.Key.IndexOf("x-rate-limit-window")]
        $RateLimitSize = $LMException.Exception.Response.Headers.Value[$LMException.Exception.Response.Headers.Key.IndexOf("x-rate-limit-limit")]
        #$RateLimitRemaining = $LMException.Exception.Response.Headers.Value[$LMException.Exception.Response.Headers.Key.IndexOf("x-rate-limit-remaining")]

        Write-Host "Request exceeded rate limit window of $RateLimitSize requests over $RateLimitWindow seconds, retrying operation in $RateLimitWindow seconds" -ForegroundColor Yellow
        Start-Sleep -Seconds $RateLimitWindow
        return $true
    }
    #Handle all other errors
    ELse {
        Switch ($LMException.Exception.GetType().FullName) {
            { "System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException" } {
                $HttpException = ($LMException.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                $HttpStatusCode = $LMException.Exception.Response.StatusCode.value__
                [Console]::ForegroundColor = 'red'
                [Console]::Error.WriteLine("Failed to execute web request($($HttpStatusCode)): $HttpException")
                [Console]::ResetColor()
            }
            default {
                $LMError = $LMException.ToString()
                [Console]::ForegroundColor = 'red'
                [Console]::Error.WriteLine("Failed to execute web request: $LMError")
                [Console]::ResetColor()
            }
        }
        Return $false
    }
}