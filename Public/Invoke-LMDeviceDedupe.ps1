Function Invoke-LMDeviceDedupe {

    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName = 'List',Mandatory)]
        [Switch]$ListDuplicates,
        
        [Parameter(ParameterSetName = 'Remove',Mandatory)]
        [Switch]$RemoveDuplicates,

        [String]$DeviceGroupId,

        [String[]]$IpExclusionList,

        [String[]]$SysNameExclusionList,

        [String[]]$ExcludeDeviceType = @(8) #Exclude K8s resources by default
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            $DeviceList = @()

            $IpExclusionList += @("127.0.0.1","::1")

            $SysNameExclusionList += @("(none)","N/A","none","blank","empty","")
            
            If($DeviceGroupId){
                $DeviceList = Get-LMDeviceGroupDevices -Id $DeviceGroupId
            }
            Else{
                $DeviceList = Get-LMDevice
            }

            #Remove excluded device types
            $DeviceList = $DeviceList | Where-Object {$ExcludeDeviceType -notcontains $_.deviceType}

            If($DeviceList){
                $OrganizedDevicesList = @()
                $DuplicateSysNameList = @()
                $RemainingDeviceList = @()

                $OutputList = @()

                #Loop through list and compare sysname, hostname and ips
                Foreach($Device in $DeviceList){
                    $IpList = $null
                    $IpListIndex = $Device.systemProperties.name.IndexOf("system.ips")
                    If($IpListIndex -ne -1){
                        $IpList = $Device.systemProperties[$IpListIndex].value
                    }

                    $SysName = $null
                    $SysNameIndex = $Device.systemProperties.name.IndexOf("system.sysname")
                    If($SysNameIndex -ne -1){
                        $SysName = $Device.systemProperties[$SysNameIndex].value.tolower()
                    }

                    $HostName = $null
                    $HostNameIndex = $Device.systemProperties.name.IndexOf("system.hostname")
                    If($HostNameIndex -ne -1){
                        $HostName = $Device.systemProperties[$HostNameIndex].value.tolower()
                    }

                    $OrganizedDevicesList += [PSCustomObject]@{
                        ipList = $IpList
                        sysName = $SysName
                        hostName = $HostName
                        displayName = $Device.displayName
                        deviceId = $Device.id
                        currentCollectorId = $Device.currentCollectorId
                        createdOnEpoch = $Device.createdOn
                        createdOnDate = (Get-Date 01.01.1970)+([System.TimeSpan]::fromseconds($($Device.createdOn)))
                    }
                }
                #Remove items that are missing system.ips and system.sysname
                $OrganizedDevicesList = $OrganizedDevicesList | ? {$_.ipList -ne $null -or $_.sysName -ne $null}

                #group devices with matching sysname values
                $DuplicateSysNameList = $OrganizedDevicesList | Group-Object -Property sysname | Sort-Object Count -Unique -Descending | ? {$_.Count -gt 1 -and $SysNameExclusionList -notcontains $_.Name}
                
                #Group remaining devices into array so we can process for duplicate ips
                $RemainingDeviceList = ($OrganizedDevicesList | Group-Object -Property sysname | Sort-Object Count -Unique -Descending | ? {$_.Count -eq 1 -or $SysNameExclusionList -contains $_.Name}).Group
                
                #Loop through each group and add duplicates to our list
                Foreach($Group in $DuplicateSysNameList){
                    #Get the oldest device out of the group and mark as original device to keep around
                    $OriginalDeviceEpochIndex = $Group.Group.createdOnEpoch.IndexOf($($Group.Group.createdOnEpoch | sort-object -Descending | Select -last 1))
                    $OriginalDevice = $Group.Group[$OriginalDeviceEpochIndex]
                    Foreach($Device in $Group.Group){
                        If($Device.deviceId -ne $OriginalDevice.deviceId){
                            $OutputList += [PSCustomObject]@{
                                duplicate_deviceId = $Device.deviceId
                                duplicate_sysName = $Device.sysName
                                duplicate_hostName = $Device.hostName
                                duplicate_displayName = $Device.displayName
                                duplicate_currentCollectorId = $Device.currentCollectorId
                                duplicate_createdOnEpoch = $Device.createdOnEpoch
                                duplicate_createdOnDate = $Device.createdOnDate
                                duplicate_ipList = $Device.ipList
                                original_deviceId = $OriginalDevice.deviceId
                                original_sysName = $OriginalDevice.sysName
                                original_hostName = $OriginalDevice.hostName
                                original_displayName = $OriginalDevice.displayName
                                original_currentCollectorId = $OriginalDevice.currentCollectorId
                                original_createdOnEpoch = $OriginalDevice.createdOnEpoch
                                original_createdOnDate = $OriginalDevice.createdOnDate
                                original_ipList = $OriginalDevice.ipList
                                duplicate_reason = "device is considered a duplicate for having a matching sysname value of $($Device.sysName) with $($Group.Count) devices"
                            }
                        }
                    }
                }
                
                $DuplicateIPDeviceList = @()
                $DuplicateIPDeviceGroupList = @()

                #Find duplicate ips for use to locate
                $DuplicateIPList = @()
                $DuplicateIPList = ($RemainingDeviceList.iplist.split(",") | Group-Object | ?{ $_.Count -gt 1 -and $IpExclusionList -notcontains $_.Name}).Group | Select-Object -Unique

                If($DuplicateIPList){
                    Foreach($Device in $RemainingDeviceList){
                        #TODO process system.ips list for dupes if assigned to same collector id
                        $DuplicateCheckResult = @()
                        $DuplicateCheckResult = Compare-Object -ReferenceObject $DuplicateIpList -DifferenceObject $($Device.ipList).split(",") -IncludeEqual -ExcludeDifferent -PassThru
                        If($DuplicateCheckResult){
                            $DuplicateIPDeviceList += [PSCustomObject]@{
                                deviceId = $Device.deviceId
                                ipList = $Device.ipList
                                sysName = $Device.sysName
                                hostName = $Device.hostName
                                displayName = $Device.displayName
                                currentCollectorId = $Device.currentCollectorId
                                createdOnEpoch = $Device.createdOnEpoch
                                createdOnDate = $Device.createdOnDate
                                duplicate_ips = $DuplicateCheckResult -join ","
                            }
                        }
                    }
                }

                #Group devices with the same duplicate IPs so we can add them to our group
                $DuplicateIPDeviceGroupList = $DuplicateIPDeviceList | Group-Object -Property duplicate_ips | Sort-Object Count -Unique -Descending | ? {$_.count -gt 1}
                Foreach($Group in $DuplicateIPDeviceGroupList){
                    #Get the oldest device out of the group and mark as original device to keep around
                    $OriginalDeviceEpochIndex = $Group.Group.createdOnEpoch.IndexOf($($Group.Group.createdOnEpoch | sort-object -Descending | Select -last 1))
                    $OriginalDevice = $Group.Group[$OriginalDeviceEpochIndex]
                    Foreach($Device in $Group.Group){
                        If($Device.deviceId -ne $OriginalDevice.deviceId){
                            $OutputList += [PSCustomObject]@{
                                duplicate_deviceId = $Device.deviceId
                                duplicate_sysName = $Device.sysName
                                duplicate_hostName = $Device.hostName
                                duplicate_displayName = $Device.displayName
                                duplicate_currentCollectorId = $Device.currentCollectorId
                                duplicate_createdOnEpoch = $Device.createdOnEpoch
                                duplicate_createdOnDate = $Device.createdOnDate
                                duplicate_ipList = $Device.ipList
                                original_deviceId = $OriginalDevice.deviceId
                                original_sysName = $OriginalDevice.sysName
                                original_hostName = $OriginalDevice.hostName
                                original_displayName = $OriginalDevice.displayName
                                original_currentCollectorId = $OriginalDevice.currentCollectorId
                                original_createdOnEpoch = $OriginalDevice.createdOnEpoch
                                original_createdOnDate = $OriginalDevice.createdOnDate
                                original_ipList = $OriginalDevice.ipList
                                duplicate_reason = "device is considered a duplicate for having a matching system.ips value of $($Device.duplicate_ips) with $($Group.Count) devices"
                            }
                        }
                    }
                }
                If($OutputList){
                    If($ListDuplicates){
                        Return (Add-ObjectTypeInfo -InputObject $OutputList -TypeName "LogicMonitor.DedupeList" )
                    }
                    ElseIf($RemoveDuplicates){
                        Foreach($Device in $OutputList){
                            #Remove duplicate devices
                            Write-LMHost "Removing device ($($Device.duplicate_deviceId)) $($Device.duplicate_displayName) for reason: $($Device.duplicate_reason)"
                            Remove-LMDevice -Id $Device.duplicate_deviceId
                        }
                    }
                }
                Else{
                    Write-LMHost "No duplicates detected based on set parameters."
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
