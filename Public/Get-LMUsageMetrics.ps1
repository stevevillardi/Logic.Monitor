Function Get-LMUsageMetrics
{

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param ()
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){
        
        #Build header and uri
        $ResourcePath = "/metrics/usage"

        Try{
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            $Request = Invoke-WebRequest -Uri $Uri -Method "GET" -Headers $Headers
            $Response = $Request.Content | ConvertFrom-Json

            Return $Response
        }
        Catch{
            $LMError = $_.ErrorDetails | ConvertFrom-Json
            Write-Error "Failed to execute query: $($LMError.errorMessage) - $($LMError.errorCode)"
        }
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
