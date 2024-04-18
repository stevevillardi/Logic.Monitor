<#
.SYNOPSIS
Creates a new alert acknowledgment in LogicMonitor.

.DESCRIPTION
The New-LMAlertAck function is used to create a new alert acknowledgment in LogicMonitor. It sends a POST request to the LogicMonitor API to acknowledge one or more alerts.

.PARAMETER Ids
Specifies the alert IDs to be acknowledged. This parameter is mandatory and accepts an array of strings.

.PARAMETER Note
Specifies the note to be added to the acknowledgment. This parameter is mandatory and accepts a string.

.EXAMPLE
New-LMAlertAck -Ids @("12345","67890") -Note "Acknowledging alerts"

This example acknowledges the alerts with the IDs "12345" and "67890" and adds the note "Acknowledging alerts" to the acknowledgment.

.NOTES
This function requires a valid API authentication. Make sure you are logged in before running any commands by using the Connect-LMAccount function.
#>
Function New-LMAlertAck {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [String[]]$Ids,
        [Parameter(Mandatory)]
        [String]$Note
    )
    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/alert/alerts/ack"

            Try {

                $Data = @{
                    alertIds = $Ids
                    ackComment  = $Note
                }

                $Data = ($Data | ConvertTo-Json)
                
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-WebRequest -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                If($Response.StatusCode -eq 200){
                    Return "Successfully acknowledged alert id(s): $Ids"
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
