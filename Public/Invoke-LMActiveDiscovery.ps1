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
        If ($global:LMAuth.Valid) {

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
                    Write-Host "Wildcard values not supported for group names." -ForegroundColor Yellow
                    return
                }
                $deviceList = (Get-LMDeviceGroupDevices -Name $GroupName).Id
                If (!$deviceList) {
                    Write-Host "Unable to find devices for group: $GroupName, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }
            ElseIf ($GroupId) {
                $deviceList = (Get-LMDeviceGroupDevices -Id $GroupId).Id
                If (!$deviceList) {
                    Write-Host "Unable to find devices for groupId: $GroupId, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }
                    
            
            #Loop through requests 
            Foreach ($device in $deviceList) {
                
                #Build header and uri
                $ResourcePath = "/device/devices/$device/scheduleAutoDiscovery"

                Try {
    
                    $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath
                    $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers
                    Write-Host "Scheduled Active Discovery task for device id: $device." -ForegroundColor green
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
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
