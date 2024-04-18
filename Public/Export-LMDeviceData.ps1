<#
.SYNOPSIS
Exports device data from Logic Monitor.

.DESCRIPTION
The Export-LMDeviceData function exports device data from Logic Monitor based on the specified parameters. It collects data from the specified devices, their datasources, and their instances within a specified time range. The exported data can be saved in JSON or CSV format.

.PARAMETER DeviceId
Specifies the ID of the device to export data for. This parameter is mutually exclusive with the DeviceDisplayName, DeviceHostName, DeviceGroupId, and DeviceGroupName parameters.

.PARAMETER DeviceDisplayName
Specifies the display name of the device to export data for. This parameter is mutually exclusive with the DeviceId, DeviceHostName, DeviceGroupId, and DeviceGroupName parameters.

.PARAMETER DeviceHostName
Specifies the host name of the device to export data for. This parameter is mutually exclusive with the DeviceId, DeviceDisplayName, DeviceGroupId, and DeviceGroupName parameters.

.PARAMETER DeviceGroupId
Specifies the ID of the device group to export data for. This parameter is mutually exclusive with the DeviceId, DeviceDisplayName, DeviceHostName, and DeviceGroupName parameters.

.PARAMETER DeviceGroupName
Specifies the name of the device group to export data for. This parameter is mutually exclusive with the DeviceId, DeviceDisplayName, DeviceHostName, and DeviceGroupId parameters.

.PARAMETER StartDate
Specifies the start date and time for the data collection. By default, it is set to the current date and time minus 1 hour.

.PARAMETER EndDate
Specifies the end date and time for the data collection. By default, it is set to the current date and time.

.PARAMETER DatasourceIncludeFilter
Specifies the filter for including specific datasources. By default, it includes all datasources.

.PARAMETER DatasourceExcludeFilter
Specifies the filter for excluding specific datasources. By default, no datasources are excluded.

.PARAMETER ExportFormat
Specifies the format for exporting the data. Valid values are "csv", "json", or "none". By default, it is set to "none".

.PARAMETER ExportPath
Specifies the path where the exported data will be saved. By default, it is set to the current location.

.EXAMPLE
Export-LMDeviceData -DeviceId 12345 -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -ExportFormat json -ExportPath "C:\LMData"

Exports device data for the device with ID 12345, collecting data for the last 7 days and saving it in JSON format at the specified path.

.EXAMPLE
Export-LMDeviceData -DeviceGroupName "Production Servers" -StartDate (Get-Date).AddHours(-12) -ExportFormat csv

Exports device data for all devices in the "Production Servers" group, collecting data for the last 12 hours and saving it in CSV format at the current location.

#>
Function Export-LMDeviceData {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'DeviceId')]
        [Int]$DeviceId,

        [Parameter(Mandatory, ParameterSetName = 'DeviceDisplayName')]
        [String]$DeviceDisplayName,

        [Parameter(Mandatory, ParameterSetName = 'DeviceHostName')]
        [String]$DeviceHostName,

        [Parameter(Mandatory, ParameterSetName = 'DeviceGroupId')]
        [String]$DeviceGroupId,

        [Parameter(Mandatory, ParameterSetName = 'DeviceGroupName')]
        [String]$DeviceGroupName,

        [Datetime]$StartDate = (Get-Date).AddHours(-1),

        [Datetime]$EndDate = (Get-Date),

        [String]$DatasourceIncludeFilter = "*",

        [String]$DatasourceExcludeFilter = $null,

        [ValidateSet("csv", "json", "none")]
        [String]$ExportFormat = 'none',

        [String]$ExportPath = (Get-Location).Path
    )

    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        $DeviceList = @()
        $DataExportList = @()
        Switch($PSCmdlet.ParameterSetName){
            "DeviceId" { $DeviceList = Get-LMDevice -Id $DeviceId }
            "DeviceName" { $DeviceList = Get-LMDevice -DisplayName $DeviceName }
            "DeviceHostName" { $DeviceList = Get-LMDevice -Name $DeviceHostName }
            "DeviceGroupId" { $DeviceList = Get-LMDeviceGroupDevices -Id $DeviceGroupId }
            "DeviceGroupName" { $DeviceList = Get-LMDeviceGroupDevices -Name $DeviceGroupName }
        }

        If($DeviceList){
            Write-LMHost "[INFO]: $(($DeviceList | Measure-Object).count) resource(s) selected for data export"
            Foreach($Device in $DeviceList){
                $DatasourceList = @()
                Write-LMHost "[INFO]: Starting data collection for resource: $($Device.displayName)"
                $DatasourceList = Get-LMDeviceDatasourceList -Id $Device.id | Where-Object { $_.monitoringInstanceNumber -gt 0 -and $_.dataSourceName -like $DatasourceIncludeFilter -and $_.datasourceName -notlike $DatasourceExcludeFilter}
                If($DatasourceList){
                    Write-LMHost "[INFO]: Found ($(($DatasourceList | Measure-Object).count)) datasource(s) with 1 or more active instances for resource: $($Device.displayName) using datasource filter (Include:$DatasourceIncludeFilter | Exclude:$DatasourceExcludeFilter)"
                    Foreach($Datasource in $DatasourceList){
                        Write-LMHost "[INFO]: Starting instance discovery for datasource $($Datasource.dataSourceName) for resource: $($Device.displayName)"
                        $InstanceList = @()
                        $InstanceList = Get-LMDeviceDatasourceInstance -Id $Device.id -DatasourceId $Datasource.dataSourceId | Where-Object { $_.stopMonitoring -eq $false}
                        If($InstanceList){
                            Write-LMHost "[INFO]: Found ($(($InstanceList | Measure-Object).count)) instance(s) for resource: $($Device.displayName)"
                            Foreach($Instance in $InstanceList){
                                Write-LMHost "[INFO]: Starting datapoint collection for instance $($Instance.name) for resource: $($Device.displayName)"
                                $Datapoints = @()
                                $Datapoints = Get-LMDeviceData -DeviceId $Device.id -DatasourceId $Datasource.dataSourceId -InstanceId $Instance.id -StartDate $StartDate -EndDate $EndDate
                                If($Datapoints){
                                    Write-LMHost "[INFO]: Finished datapoint collection for instance $($Instance.name) for resource: $($Device.displayName)"
                                    $DataExportList += [PSCustomObject]@{
                                        deviceId = $Device.id
                                        deviceName = $Device.displayName
                                        datasourceName = $Datasource.dataSourceName
                                        instanceName = $Instance.name
                                        instanceGroup = $Instance.groupName
                                        dataPoints = $Datapoints
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
            Switch($ExportFormat){
                "json" { $DataExportList | ConvertTo-Json -Depth 3 | Out-File -FilePath "$ExportPath\LMDeviceDataExport.json" ; return }
                "csv" { $DataExportList | Export-Csv -NoTypeInformation -Path  "$ExportPath\LMDeviceDataExport.csv" ;  return }
                default { return $DataExportList }
            }
        }
        Else{
            Write-Error "No resources found using supplied parameters, please check you settings and try again."
        }
        
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
