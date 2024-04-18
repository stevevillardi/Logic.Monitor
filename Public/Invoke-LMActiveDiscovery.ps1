<#
.SYNOPSIS
    Invokes an active discovery task for LogicMonitor devices.

.DESCRIPTION
    The Invoke-LMActiveDiscovery function is used to schedule an active discovery task for LogicMonitor devices. 
    It accepts parameters to specify the devices for which the active discovery task should be scheduled.

.PARAMETER Id
    Specifies the ID of the device for which the active discovery task should be scheduled. This parameter is mutually exclusive with the Name parameter.

.PARAMETER Name
    Specifies the name of the device for which the active discovery task should be scheduled. This parameter is mutually exclusive with the Id parameter.

.PARAMETER GroupId
    Specifies the ID of the device group for which the active discovery task should be scheduled. This parameter is mutually exclusive with the GroupName parameter.

.PARAMETER GroupName
    Specifies the name of the device group for which the active discovery task should be scheduled. This parameter is mutually exclusive with the GroupId parameter.

.NOTES
    - This function requires a valid API authentication. Make sure you are logged in before running any commands.
    - Use the Connect-LMAccount function to log in and obtain valid API credentials.

.EXAMPLE
    Invoke-LMActiveDiscovery -Id 12345
    Invokes an active discovery task for the device with ID 12345.

.EXAMPLE
    Invoke-LMActiveDiscovery -Name "MyDevice"
    Invokes an active discovery task for the device with the name "MyDevice".

.EXAMPLE
    Invoke-LMActiveDiscovery -GroupId "123"
    Invokes an active discovery task for all devices in the device group with ID "123".

.EXAMPLE
    Invoke-LMActiveDiscovery -GroupName "Group2"
    Invokes an active discovery task for all devices in the device group with the name "Group2".
#>
Function Invoke-LMActiveDiscovery {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [String]$GroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$GroupName
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            $deviceList = @()

            #Lookup device name
            If ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $deviceList = $LookupResult
            }
            ElseIf ($Id) {
                $deviceList = $Id
            }

            #Look up devices by group
            If ($GroupName) {
                If ($GroupName -Match "\*") {
                    Write-Error "Wildcard values not supported for group names." 
                    return
                }
                $deviceList = (Get-LMDeviceGroupDevices -Name $GroupName).Id
                If (!$deviceList) {
                    Write-Error "Unable to find devices for group: $GroupName, please check spelling and try again." 
                    return
                }
            }
            ElseIf ($GroupId) {
                $deviceList = (Get-LMDeviceGroupDevices -Id $GroupId).Id
                If (!$deviceList) {
                    Write-Error "Unable to find devices for groupId: $GroupId, please check spelling and try again." 
                    return
                }
            }
                    
            
            #Loop through requests 
            Foreach ($device in $deviceList) {
                
                #Build header and uri
                $ResourcePath = "/device/devices/$device/scheduleAutoDiscovery"
               
                Try {
    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    Write-Host "Scheduled Active Discovery task for device id: $device."
                }
                Catch [Exception] {
                    $Proceed = Resolve-LMException -LMException $PSItem
                    If (!$Proceed) {
                        Return
                    }
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
