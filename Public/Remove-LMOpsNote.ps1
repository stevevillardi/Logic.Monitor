<#
.SYNOPSIS
Removes an OpsNote from LogicMonitor.

.DESCRIPTION
The Remove-LMOpsNote function removes an OpsNote from LogicMonitor. It requires the user to be logged in and have valid API credentials.

.PARAMETER Id
Specifies the ID of the OpsNote to be removed.

.EXAMPLE
Remove-LMOpsNote -Id "12345"
Removes the OpsNote with the ID "12345" from LogicMonitor.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject
Returns an object with the ID and a success message if the OpsNote is successfully removed.
#>
Function Remove-LMOpsNote {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/opsnotes/$Id"

            $Message = "Id: $Id"

            #Loop through requests 
            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove OpsNote")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    $Result = [PSCustomObject]@{
                        Id = $Id
                        Message = "Successfully removed ($Message)"
                    }
                    
                    Return $Result
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
    End {}
}
