<#
.SYNOPSIS
Removes a LogicMonitor configsource.

.DESCRIPTION
The Remove-LMConfigsource function removes a LogicMonitor configsource based on the specified Id or Name. It requires valid API credentials and the user must be logged in before running any commands.

.PARAMETER Id
Specifies the Id of the configsource to remove. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
Specifies the Name of the configsource to remove. This parameter is mandatory when using the 'Name' parameter set.

.INPUTS
You can pipe input to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject
Returns an object with the following properties:
- Id: The Id of the removed configsource.
- Message: A message indicating the success of the removal operation.

.EXAMPLE
Remove-LMConfigsource -Id 123
Removes the configsource with Id 123.

.EXAMPLE
Remove-LMConfigsource -Name "ConfigSource1"
Removes the configsource with the name "ConfigSource1".

.NOTES
Please ensure you are logged in before running any commands. Use Connect-LMAccount to login and try again.
#>
Function Remove-LMConfigsource {

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
            $ResourcePath = "/setting/configsources/$Id"

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
                If ($PSCmdlet.ShouldProcess($Message, "Remove Configsource")) {                    
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
