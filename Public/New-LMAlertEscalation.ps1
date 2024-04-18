<#
.SYNOPSIS
Creates a new escalation for a LogicMonitor alert.

.DESCRIPTION
The New-LMAlertEscalation function creates a new escalation for a LogicMonitor alert. It checks if the user is logged in and has valid API credentials before making the API request to create the escalation.

.PARAMETER Id
The ID of the alert for which the escalation needs to be created.

.EXAMPLE
New-LMAlertEscalation -Id "DS12345"
Creates a new escalation for the alert with ID "12345".

#>

Function New-LMAlertEscalation {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id
    )
    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/alert/alerts/$Id/escalate"

            Try {
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-WebRequest -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1]

                If($Response.StatusCode -eq 200){
                    Return "Successfully escalated alert id: $Id"
                }
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
    End{}
}
