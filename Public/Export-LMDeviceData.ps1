Function Export-LMDeviceData {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'DeviceId')]
        [Int]$DeviceId,

        [Parameter(Mandatory, ParameterSetName = 'DeviceName')]
        [String]$DeviceName,

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
    If ($global:LMAuth.Valid) {
        $DeviceList = @()
        $DataExportList = @()
        Switch($PSCmdlet.ParameterSetName){
            "DeviceId" { $DeviceList = Get-LMDevice -Id $DeviceId }
            "DeviceName" { $DeviceList = Get-LMDevice -Name $DeviceName }
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
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
