<#
.SYNOPSIS
    Function to handle exceptions that occur during API requests.

.DESCRIPTION
    The Resolve-LMException function is used to handle exceptions that occur during API requests and throttle the requests if they exceed the rate limit.

.PARAMETER LMException
    The exception object that is thrown during the API request.

.EXAMPLE
    Resolve-LMException -LMException $exception
#>
Function Resolve-LMException {
    Param (
        $LMException
    )
    #Add in rate limit handling
    If ($LMException.Exception.Response.StatusCode.value__ -eq 429) {
        $RateLimitWindow = $LMException.Exception.Response.Headers.Value[$LMException.Exception.Response.Headers.Key.IndexOf("x-rate-limit-window")]
        $RateLimitSize = $LMException.Exception.Response.Headers.Value[$LMException.Exception.Response.Headers.Key.IndexOf("x-rate-limit-limit")]
        #$RateLimitRemaining = $LMException.Exception.Response.Headers.Value[$LMException.Exception.Response.Headers.Key.IndexOf("x-rate-limit-remaining")]

        Write-LMHost "Request exceeded rate limit window of $RateLimitSize requests over $RateLimitWindow seconds, retrying operation in $RateLimitWindow seconds" -ForegroundColor Yellow
        Start-Sleep -Seconds $RateLimitWindow
        return $true
    }
    #Handle all other errors
    ELse {
        Switch ($LMException.Exception.GetType().FullName) {
            { "System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException" } {
                Try{
                    $HttpException = ($LMException.ErrorDetails.Message | ConvertFrom-Json -ErrorAction SilentlyContinue).errorMessage
                    If (!$HttpException) {
                        $HttpException = ($LMException.ErrorDetails.Message | ConvertFrom-Json -ErrorAction Stop).message
                    }
                }
                Catch{
                    $HttpException = $LMException.ErrorDetails.Message
                }
                $HttpStatusCode = $LMException.Exception.Response.StatusCode.value__
                #Output to null so ErrorAction works as expected
                Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException" 2>$null
                #Write to $Error object but suppress so stack trace is not displayed
                Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException" -ErrorAction SilentlyContinue
                #Pretty print error to console
                If($ErrorActionPreference -ne "SilentlyContinue"){
                    [Console]::ForegroundColor = 'red'
                    [Console]::Error.WriteLine("Failed to execute web request($($HttpStatusCode)): $HttpException")
                    [Console]::ResetColor()
                    #throw "Failed to execute web request($($HttpStatusCode)): $HttpException"
                }
            }
            default {
                $LMError = $LMException.ToString()
                #Output to null so ErrorAction works as expected
                Write-Error "Failed to execute web request: $LMError" 2>$null
                #Write to $Error object but suppress so stack trace is not displayed
                Write-Error "Failed to execute web request: $LMError" -ErrorAction SilentlyContinue
                #Pretty print error to console
                If($ErrorActionPreference -ne "SilentlyContinue"){
                    [Console]::ForegroundColor = 'red'
                    [Console]::Error.WriteLine("Failed to execute web request: $LMError")
                    [Console]::ResetColor()
                    #throw "Failed to execute web request: $LMError"
                }
            }
        }
        Return $false
    }
}