<#
.SYNOPSIS
Invokes a NetScan task in LogicMonitor.

.DESCRIPTION
The Invoke-LMNetScan function is used to execute a NetScan task in LogicMonitor. It checks if the user is logged in and has valid API credentials before making the API call. If the user is logged in, it builds the necessary headers and URI, and then issues a GET request to execute the NetScan task. If the request is successful, it returns a message indicating that the NetScan task has been scheduled.

.PARAMETER Id
The ID of the NetScan task to be executed. This parameter is mandatory.

.EXAMPLE
Invoke-LMNetScan -Id "12345"
Schedules the NetScan task with ID "12345" in LogicMonitor.

#>

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
    
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
                
                Return "Scheduled NetScan task for NetScan id: $Id."
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
