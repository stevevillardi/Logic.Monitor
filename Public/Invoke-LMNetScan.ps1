Function Invoke-LMNetScan {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Id
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
                
            #Build header and uri
            $ResourcePath = "/setting/netscans/$id/executenow"

            Try {
    
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers
                Write-LMHost "Scheduled NetScan task for NetScan id: $Id." -ForegroundColor green
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
    End {}
}
