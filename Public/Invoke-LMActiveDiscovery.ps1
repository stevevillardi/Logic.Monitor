Function Invoke-LMActiveDiscovery {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
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
