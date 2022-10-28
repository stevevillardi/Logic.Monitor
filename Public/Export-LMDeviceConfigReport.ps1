<#
.SYNOPSIS
Exports an HTML report containing changed network configs

.DESCRIPTION
Export device config change report based on the number of days specified, defaults to using the Devices by Type/Network folder

.PARAMETER DeviceGroupId
Device group id for the group to use as the source of running the report, defaults to Devices by Type/Network folder if not specified

.PARAMETER DaysBack
Number of days back to run the report, defaults to 7 if not specified

.PARAMETER Path
Path to export the HTML report to

.PARAMETER OpenOnCompletetion
Open the output htmml report automatically once completed

.EXAMPLE
Export-LMDeviceConfigReport -DaysBack 30 -DeviceGroupId 2 -Path export-report.html

.EXAMPLE
Export-LMDeviceConfigReport -Path export-report.html -OpenOnCompletetion

.NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>

Function Export-LMDeviceConfigReport {

    [CmdletBinding()]
    Param (
        [Int]$DeviceGroupId,

        [String]$DaysBack = 7,
        
        [Parameter(Mandatory)]
        [String]$Path,

        [Switch]$OpenOnCompletetion
    )

    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        $ShowHtml = $false
        If($OpenOnCompletetion){
            $ShowHtml = $true
        }

        If (!$DeviceGroupId) {
            #Grab Devices by Type folder
            $devices_by_type_id = (Get-LMDeviceGroup -Name "Devices by Type" | Sort-Object -Property Id | Select-Object -First 1).id
            If($devices_by_type_id){
                #Grab Network group to focus on
                $network_group_id = (Get-LMDeviceGroupGroups -Id $devices_by_type_id | ? { $_.fullPath -eq "Devices by Type/Network" }).id
        
                #Grab devices inside Network group
                $network_devices = Get-LMDeviceGroupDevices -id $network_group_id
            }
            Else{
                Write-Error "Default report device group Devices by Type could not be located, please specify a DeviceGroupId to use for running this export"
            }
        }
        Else {
            $network_devices = Get-LMDeviceGroupDevices -id $DeviceGroupId
        }

        #Loop through Network group devices and pull list of applied ConfigSources
        $instance_list = @()
        Foreach ($device in $network_devices) {
            $device_config_sources = Get-LMDeviceDatasourceList -id $device.id | ? { $_.dataSourceType -eq "CS" }

            #Loop through DSes and pull all instances matching running or current and add them to processing list
            Foreach ($config_source in $device_config_sources) {
                $running_config_instance = Get-LMDeviceDatasourceInstance -id $config_source.deviceId -DatasourceId $config_source.dataSourceId | ? { $_.displayName -like "*running*" -or $_.displayName -like "*current*" -or $_.name -like "PaloAlto*" } | Select-Object -First 1
                If ($running_config_instance) {
                    $instance_list += [PSCustomObject]@{
                        deviceId              = $device.id
                        deviceDisplayName     = $device.displayName
                        dataSourceId          = $config_source.id
                        dataSourceName        = $config_source.datasourceName
                        dataSourceDisplayname = $config_source.dataSourceDisplayname
                        instanceDisplayName   = $running_config_instance.displayName
                        instanceDescription   = $running_config_instance.description
                        instanceId            = $running_config_instance.id
    
                    }
                }
                Else {
                    #No instance found based on filter criteria
                    #Write-Host "No instance found for $($config_source.datasourceName)"
                }
            }
        }

        #Loop through filtered instance list and pull config diff
        $device_configs = @()
        Foreach ($instance in $instance_list) {
            $device_configs += Get-LMDeviceConfigSourceDiff -id $instance.deviceId -HdsId $instance.dataSourceId -HdsInsId $instance.instanceId
        }

        #We found some config changes, let organize them
        $output_list = @()
        If ($device_configs) {
            #Get start and end epoch range
            $start_date = [Math]::Floor((New-TimeSpan -Start (Get-Date "01/01/1970") -End ((Get-Date).AddDays(-$DaysBack).ToUniversalTime())).TotalMilliseconds)
            $end_date = [Math]::Floor((New-TimeSpan -Start (Get-Date "01/01/1970") -End ((Get-Date).ToUniversalTime())).TotalMilliseconds)

            #Remove old configs from report to limit processing
            $device_configs = $device_configs | ? { $_.pollTimestamp -ge $start_date -and $_.pollTimestamp -le $end_date }

            #Group Configs by device so we can work through each set
            $config_grouping = $device_configs | Group-Object -Property deviceId

            #Loop through each set and built report
            Foreach ($device in $config_grouping) {
                Foreach ($config in $device.Group) {
                    Foreach ($line in $config.deltaConfig) {
                        $output_list += [PSCustomObject]@{
                            deviceDisplayName        = $config.deviceDisplayName
                            deviceInstanceName       = $config.instanceName
                            devicePollTimestampEpoch = $config.pollTimestamp
                            devicePollTimestampUTC   = [datetimeoffset]::FromUnixTimeMilliseconds($config.pollTimestamp).DateTime
                            deviceConfigVersion      = $config.version
                            configChangeType         = $line.type
                            configChangeRow          = $line.rowNo
                            configChangeContent      = $line.content
                        }
                    }
                }
            }
        }


        #Generate HTML Report
        New-HTML -TitleText "LogicMonitor - Config Report" -ShowHTML:$ShowHtml -Online -FilePath $Path {
            New-HTMLPanel {
                New-HTMLTable -DataTable $output_list -HideFooter -ScrollCollapse -PagingLength 1000 {
                    New-TableHeader -Title "LogicMonitor - Config Report (Last $DaysBack days)" -Alignment center -BackGroundColor BuddhaGold -Color White -FontWeight bold
                    New-TableRowGrouping -Name "deviceDisplayName"
                }
            }
        }
        
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
