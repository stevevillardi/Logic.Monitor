<#
.SYNOPSIS
Removes a property from a LogicMonitor device.

.DESCRIPTION
The Remove-LMDeviceProperty function removes a specified property from a LogicMonitor device. It can remove the property either by providing the device ID or the device name.

.PARAMETER Id
The ID of the device from which the property should be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the device from which the property should be removed. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER PropertyName
The name of the property to be removed. This parameter is mandatory.

.EXAMPLE
Remove-LMDeviceProperty -Id 1234 -PropertyName "Property1"
Removes the property named "Property1" from the device with ID 1234.

.EXAMPLE
Remove-LMDeviceProperty -Name "Device1" -PropertyName "Property2"
Removes the property named "Property2" from the device with the name "Device1".

.INPUTS
None.

.OUTPUTS
System.Management.Automation.PSCustomObject. The output object contains the following properties:
- Id: The ID of the device from which the property was removed.
- Message: A message indicating the success of the operation.

.NOTES
- This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running any commands.
- Use the Connect-LMAccount function to log in before using this function.
#>
Function Remove-LMDeviceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$PropertyName

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/device/devices/$Id/properties/$PropertyName"

            If($Name){
                $Message = "Id: $Id | Name: $Name | Property: $PropertyName"
            }
            Else{
                $Message = "Id: $Id | Property: $PropertyName"
            }

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Device Property")) {                    
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
