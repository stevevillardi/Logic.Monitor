<#
.SYNOPSIS
Removes a LogicMonitor Netscan.

.DESCRIPTION
The Remove-LMNetscan function is used to remove a LogicMonitor Netscan. It supports removing a Netscan by either its Id or Name.

.PARAMETER Id
Specifies the Id of the Netscan to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the Name of the Netscan to remove. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMNetscan -Id 123
Removes the Netscan with Id 123.

.EXAMPLE
Remove-LMNetscan -Name "MyNetscan"
Removes the Netscan with the name "MyNetscan".

.INPUTS
You can pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. The function returns an object with the following properties:
- Id: The Id of the removed Netscan.
- Message: A message indicating the success of the removal operation.
#>
Function Remove-LMNetscan {

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
                $LookupResult = (Get-LMNetscan -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/setting/netscans/$Id"

            If($PSItem){
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            ElseIf($Name){
                $Message = "Id: $Id | Name: $Name"
            }
            Else{
                $Message = "Id: $Id"
            }

            #Loop through requests 
            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove NetScan")) {                    
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
