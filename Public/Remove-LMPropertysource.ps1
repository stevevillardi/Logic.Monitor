<#
.SYNOPSIS
Removes a property source from LogicMonitor.

.DESCRIPTION
The Remove-LMPropertysource function removes a property source from LogicMonitor. It can remove a property source either by its ID or by its name.

.PARAMETER Id
Specifies the ID of the property source to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the name of the property source to be removed. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMPropertysource -Id 123
Removes the property source with ID 123.

.EXAMPLE
Remove-LMPropertysource -Name "MyPropertySource"
Removes the property source with the name "MyPropertySource".

.INPUTS
You can pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. The function returns an object with the following properties:
- Id: The ID of the removed property source.
- Message: A message indicating the success of the removal operation.
#>
Function Remove-LMPropertysource {

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

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMPropertySource -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            
            #Build header and uri
            $ResourcePath = "/setting/propertyrules/$Id"

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
                If ($PSCmdlet.ShouldProcess($Message, "Remove Propertysource")) {                    
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
