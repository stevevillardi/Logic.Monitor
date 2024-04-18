<#
.SYNOPSIS
Removes a LogicMonitor report.

.DESCRIPTION
The Remove-LMReport function removes a LogicMonitor report based on the specified report ID or name. It requires a valid API authentication and authorization.

.PARAMETER Id
Specifies the ID of the report to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the report to be removed. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMReport -Id 123
Removes the report with ID 123.

.EXAMPLE
Remove-LMReport -Name "MyReport"
Removes the report with the name "MyReport".

.INPUTS
You can pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. Returns an object with the removed report ID and a success message.

.NOTES
This function requires a valid API authentication and authorization. Use Connect-LMAccount to log in before running this command.
#>
Function Remove-LMReport {

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
                $LookupResult = (Get-LMReport -Name $Name).Id
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
            $ResourcePath = "/report/reports/$Id"

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Report")) {                    
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
