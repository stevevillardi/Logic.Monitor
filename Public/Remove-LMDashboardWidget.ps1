<#
.SYNOPSIS
Removes a dashboard widget from Logic Monitor.

.DESCRIPTION
The Remove-LMDashboardWidget function removes a dashboard widget from Logic Monitor. It can remove a widget either by its ID or by its name.

.PARAMETER Id
The ID of the widget to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the widget to be removed. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMDashboardWidget -Id 123
Removes the dashboard widget with ID 123.

.EXAMPLE
Remove-LMDashboardWidget -Name "Widget Name"
Removes the dashboard widget with the specified name.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
A PSCustomObject representing the result of the removal operation. The object has the following properties:
- Id: The ID of the removed widget.
- Message: A message indicating the success of the removal operation.

.NOTES
This function requires a valid API authentication to Logic Monitor. Make sure to log in using Connect-LMAccount before running this command.

#>
Function Remove-LMDashboardWidget {

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

            #Lookup Id if supplying widget name
            If ($Name) {
                $LookupResult = (Get-LMDashboardWidget -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/dashboard/widgets/$Id"

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
                If ($PSCmdlet.ShouldProcess($Message, "Remove Dashboard Widget")) {                    
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
