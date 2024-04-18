<#
.SYNOPSIS
Removes a LogicMonitor NetScan group.

.DESCRIPTION
The Remove-LMNetscanGroup function removes a LogicMonitor NetScan group based on the specified ID or name. It requires valid API credentials to be logged in.

.PARAMETER Id
Specifies the ID of the NetScan group to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the NetScan group to remove. This parameter is mandatory when using the 'Name' parameter set.

.INPUTS
You can pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject
Returns an object with the following properties:
- Id: The ID of the removed NetScan group.
- Message: A message indicating the success of the removal operation.

.EXAMPLE
Remove-LMNetscanGroup -Id 123
Removes the NetScan group with ID 123.

.EXAMPLE
Remove-LMNetscanGroup -Name "MyGroup"
Removes the NetScan group with the name "MyGroup".

.NOTES
This function requires valid API credentials to be logged in. Use the Connect-LMAccount function to log in before running any commands.
#>
Function Remove-LMNetscanGroup {

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
                $LookupResult = (Get-LMNetScanGroup -Name $Name).Id
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
            $ResourcePath = "/setting/netscans/groups/$Id"

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove NetScan Group")) {                    
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
