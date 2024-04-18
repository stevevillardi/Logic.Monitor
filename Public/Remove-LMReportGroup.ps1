<#
.SYNOPSIS
Removes a LogicMonitor report group.

.DESCRIPTION
The Remove-LMReportGroup function removes a LogicMonitor report group based on the specified Id or Name. It requires valid API credentials to be logged in.

.PARAMETER Id
The Id of the report group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the report group to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMReportGroup -Id 123
Removes the report group with Id 123.

.EXAMPLE
Remove-LMReportGroup -Name "MyReportGroup"
Removes the report group with the name "MyReportGroup".

.INPUTS
You can pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. Returns an object with the removed report group Id and a success message.
#>
Function Remove-LMReportGroup {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying name
            If ($Name) {
                $LookupResult = (Get-LMReportGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            If($PSItem){
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            ElseIf($Name){
                $Message = "Id: $Id | Name: $Name"
            }
            Else{
                $Message = "Id: $Id"
            }
            
            #Build header and uri
            $ResourcePath = "/report/groups/$Id"

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Report Group")) {                    
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
