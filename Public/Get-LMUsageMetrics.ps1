Function Get-LMUsageMetrics {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param ()
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/metrics/usage"

        Try {
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers

            Return $Response
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
