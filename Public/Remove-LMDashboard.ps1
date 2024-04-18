<#
.SYNOPSIS
Removes a LogicMonitor dashboard.

.DESCRIPTION
The Remove-LMDashboard function is used to remove a LogicMonitor dashboard. It supports removing a dashboard by either its ID or name.

.PARAMETER Id
Specifies the ID of the dashboard to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the dashboard to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMDashboard -Id 123
Removes the dashboard with ID 123.

.EXAMPLE
Remove-LMDashboard -Name "My Dashboard"
Removes the dashboard with the name "My Dashboard".

.INPUTS
You can pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. The function returns an object with the following properties:
- Id: The ID of the removed dashboard.
- Message: A message indicating the success of the removal operation.

.NOTES
- This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running this command.
#>
Function Remove-LMDashboard {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying dashboard name
            If ($Name) {
                $LookupResult = (Get-LMDashboard -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/dashboard/dashboards/$Id"

            If($PSItem){
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            ElseIf($Name){
                $Message = "Id: $Id | Name: $Name"
            }
            Else{
                $Message = "Id: $Id"
            }

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Dashboard")) {                    
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
    End{}
}
