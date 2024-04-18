<#
.SYNOPSIS
Removes a LogicMonitor Collector Group.

.DESCRIPTION
The Remove-LMCollectorGroup function removes a LogicMonitor Collector Group based on the provided Id or Name. It requires valid API credentials to be logged in.

.PARAMETER Id
Specifies the Id of the Collector Group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the Name of the Collector Group to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMCollectorGroup -Id 123
Removes the Collector Group with Id 123.

.EXAMPLE
Remove-LMCollectorGroup -Name "Group1"
Removes the Collector Group with Name "Group1".

.INPUTS
You can pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. The function returns an object with the Id and a success message.

.NOTES
This function requires valid API credentials to be logged in. Use Connect-LMAccount to log in before running this command.
#>
Function Remove-LMCollectorGroup {

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

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMCollectorGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            If($PSItem){
                $Message = "Id: $($PSItem.id) | Name: $($PSItem.name)"
            }
            ElseIf ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else{
                $Message = "Id: $Id"
            }
            
            #Build header and uri
            $ResourcePath = "/setting/collector/groups/$Id"

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Collector Group")) {                    
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
