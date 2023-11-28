<#
.SYNOPSIS
Exports the latest version of a device config for a select set of devices

.DESCRIPTION
Exports the latest version of a device config for a select set of devices

.PARAMETER DeviceGroupId
Device group id for the group to use as the source of running the report.

.PARAMETER DeviceId
Device id to use as the source of running the report, defaults to Devices by Type/Network folder if not specified

.PARAMETER Path
Path to export the csv backup to

.PARAMETER InstanceNameFilter
Regex filter to use to filter out Instance names used for discovery, defaults to "running|current|PaloAlto".

.PARAMETER ConfigSourceNameFilter
Regex filter to use to filter out ConfigSource names used for discovery, defaults to ".*"

.EXAMPLE
Export-LMDeviceConfigBackup -DeviceGroupId 2 -Path export-report.csv

.EXAMPLE
Export-LMDeviceConfigBackup -DeviceId 1 -Path export-report.csv


.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>

Function Export-LMDeviceConfigBackup {

    [CmdletBinding(DefaultParameterSetName="Device")]
    Param (
        [Parameter(ParameterSetName="DeviceGroup",Mandatory)]
        [Int]$DeviceGroupId,
        
        [Parameter(ParameterSetName="Device",Mandatory)]
        [Int]$DeviceId,

        [Regex]$InstanceNameFilter = "[rR]unning|[cC]urrent|[pP]aloAlto",

        [Regex]$ConfigSourceNameFilter = ".*",
        
        [Parameter()]
        [String]$Path
    )

    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If($DeviceId){
            $network_devices = Get-LMDevice -id $DeviceId
        }
        Else {
            $network_devices = Get-LMDeviceGroupDevices -id $DeviceGroupId
        }

        #Loop through Network group devices and pull list of applied ConfigSources
        $instance_list = @()
        Write-LMHost "[INFO]: Found $(($network_devices | Measure-Object).Count) devices."
        Foreach ($device in $network_devices) {
            Write-LMHost "[INFO]: Collecting configurations for: $($device.displayName)"
            $device_config_sources = Get-LMDeviceDatasourceList -id $device.id | Where-Object { $_.dataSourceType -eq "CS" -and $_.instanceNumber -gt 0 -and $_.dataSourceName -match $ConfigSourceNameFilter }

            Write-LMHost " [INFO]: Found $(($device_config_sources | Measure-Object).Count) configsource(s) with discovered instances using match filter ($ConfigSourceNameFilter)." -ForegroundColor Gray
            #Loop through DSes and pull all instances matching running or current and add them to processing list
            $filtered_config_instance_count = 0
            Foreach ($config_source in $device_config_sources) {
                $running_config_instance = Get-LMDeviceDatasourceInstance -DeviceId $config_source.deviceId -DatasourceId $config_source.dataSourceId
                $filtered_config_instance = $running_config_instance | Where-Object { $_.displayName -Match $InstanceNameFilter}
                If ($filtered_config_instance) {
                    Foreach($instance in $filtered_config_instance){
                        $filtered_config_instance_count++
                        $instance_list += [PSCustomObject]@{
                            deviceId              = $device.id
                            deviceDisplayName     = $device.displayName
                            dataSourceId          = $config_source.id
                            dataSourceName        = $config_source.datasourceName
                            dataSourceDisplayname = $config_source.dataSourceDisplayname
                            instanceDisplayName   = $instance.displayName
                            instanceDescription   = $instance.description
                            instanceId            = $instance.id
                        }
                    }
                }
            }
            Write-LMHost " [INFO]: Found $filtered_config_instance_count configsource instance(s) using match filter ($InstanceNameFilter)."  -ForegroundColor Gray
        }

        #Loop through filtered instance list and pull config diff
        $device_configs = @()
        Foreach ($instance in $instance_list) {
            $device_configs += Get-LMDeviceConfigSourceData -id $instance.deviceId -HdsId $instance.dataSourceId -HdsInsId $instance.instanceId -ConfigType Full -LatestConfigOnly
        }
        
        #We found some config changes, let organize them
        $output_list = @()
        If ($device_configs) {
            #Group Configs by device so we can work through each set
            $config_grouping = $device_configs | Group-Object -Property deviceId
            Write-LMHost "[INFO]: Collecting latest device configurations from $(($config_grouping | Measure-Object).Count) devices."
            #Loop through each set and built report
            Foreach ($device in $config_grouping) {
                $config = $device.Group | Sort-Object -Property pollTimestamp -Descending | Select-Object -First 1
                Write-LMHost " [INFO]: Found $(($device.Group | Measure-Object).Count) configsource instance version(s) for: $($config.deviceDisplayName), selecting latest config dated: $([datetimeoffset]::FromUnixTimeMilliseconds($config.pollTimestamp).DateTime)UTC"  -ForegroundColor Gray
                $output_list += [PSCustomObject]@{
                    deviceDisplayName        = $config.deviceDisplayName
                    deviceInstanceName       = $config.instanceName
                    deviceDatasourceName     = $config.dataSourceName
                    devicePollTimestampEpoch = $config.pollTimestamp
                    devicePollTimestampUTC   = [datetimeoffset]::FromUnixTimeMilliseconds($config.pollTimestamp).DateTime
                    deviceConfigVersion      = $config.version
                    configContent            = $config.config
                }
            }
        }

        If($output_list){
            If($Path){
                #Generate CSV Export
                $output_list | Export-Csv -Path $Path -NoTypeInformation
            }
            Return (Add-ObjectTypeInfo -InputObject $output_list -TypeName "LogicMonitor.ConfigBackup" )
        }
        Else{
            Write-LMHost "[WARN]: Did not find any configs to output based on selected resource(s), check your parameters and try again." -ForegroundColor Yellow
        }
        
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
