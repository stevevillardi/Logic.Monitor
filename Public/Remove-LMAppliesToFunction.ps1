<#
.SYNOPSIS
Removes an AppliesTo function from LogicMonitor.

.DESCRIPTION
The Remove-LMAppliesToFunction function removes an AppliesTo function from LogicMonitor. It can be used to remove a function either by its name or its ID.

.PARAMETER Name
Specifies the name of the AppliesTo function to be removed. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER Id
Specifies the ID of the AppliesTo function to be removed. This parameter is mandatory when using the 'Id' parameter set. The ID can be obtained using the Get-LMAppliesToFunction cmdlet.

.EXAMPLE
Remove-LMAppliesToFunction -Name "MyAppliesToFunction"
Removes the AppliesTo function with the name "MyAppliesToFunction".

.EXAMPLE
Remove-LMAppliesToFunction -Id 12345
Removes the AppliesTo function with the ID 12345.

.INPUTS
None. You cannot pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. The function returns an object with the following properties:
- Id: The ID of the removed AppliesTo function.
- Message: A message indicating the success of the removal operation.

#>
Function Remove-LMAppliesToFunction {

    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id',ValueFromPipelineByPropertyName)]
        [Int]$Id

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying name
            If ($Name) {
                $LookupResult = (Get-LMAppliesToFunction -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/setting/functions/$Id"

            If($PSItem){
                $Message = "Id: $Id | Name:$($PSItem.name)"
            }
            ElseIf ($Name) {
                $Message = "Id: $Id | Name: $Name"
            }
            Else{
                $Message = "Id: $Id"
            }

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove AppliesTo Function")) {                    
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
