# Code Snipet Examples:

#### Get last 24 hours of alerts and group by resource and datapoint

```powershell
Get-LMAlert -StartDate $(Get-Date).AddDays(-1) -EndDate $(Get-Date) -ClearedAlerts $true | Group-Object -Property resourceTemplateName,datapointName | select count, @{N='Name';E={$_.Name.Split(",")[0]}}, @{N='Datapoint';E={$_.Name.Split(",")[1]}} | Sort-Object -Property count -Descending
```

#### Generate Website inventory report with specific properties
```powershell
$ExportList = @()
$Websites = Get-LMWebsite

Foreach($Website in $Websites){
    $PropertyHash = @{}
    $Website.properties | ForEach-Object {$PropertyHash[$_.name]= $_.value}

    $ExportList += [PSCustomObject]@{
        Name = $Website.name
        Description = $Website.description
        Type = $Website.type
        "Prop.Criticality" = $PropertyHash["Prop.Criticality"]
        "CI Platform" = $PropertyHash["CI Platform"]
        "CI Role" = $PropertyHash["CI Role"]
        "CI Sub Type" = $PropertyHash["CI Sub Type"]
    }
}

$ExportList | Export-Csv -NoTypeInformation -Path "sample-report.csv"
```

#### Loop through all webchecks and list out SSL remaining days till expiration

```powershell
$Output = @()
$Websites = Get-LMWebsite -Type Webcheck
foreach($Website in $Websites){
    $WebsiteData = Get-LMWebsiteData -Id $Website.Id
    $SSLExpiration = $WebsiteData.datapoints.IndexOf("sslDaysUntilExpiration")
    If($WebsiteData.values){
      $Output += [PSCustomObject]@{
          Id = $Website.Id
          Name = $Website.Name
          Domain = $Website.Domain
          Group = $Website.GroupId
          SSLExpiration = $WebsiteData.values[0][$SSLExpiration]
      }
    }
}
$Output
```

#### Import new devices from CSV including properties

```powershell
#   Example CSV:
#   id,displayname,description,properties,collector_id,group_ids
#   "192.168.1.1","core-switch01","TX HQ switch","snmp.community=public,location=Austin TX","1","2,4,6"
#   "192.168.2.1","core-switch02","FL HQ switch","snmp.community=public,location=Oralndo FL","2","7,8,9"
#
$csvPath = "path/to/import.csv"
$devices = Import-Csv -Path $csvPath
foreach($device in $devices){
    #Break properties into hashtable
    $properties = @{}
    $device.properties.Split(",") | ConvertFrom-StringData | ForEach-Object {$properties += $_}

    #Create array of group ids if adding to more than one static group
    $hostGroups = @($device.group_ids -split ",")

    #Create new device in LM
    New-LMDevice -Name $device.ip -DisplayName $device.displayname -Description $device.description -properties $properties -PreferredCollectorId $device.collector_id -HostGroupIds $hostGroups
}
```

#### Import new device groups from CSV including properties

```powershell
#Note:this assumes parent folder names being specified are unique in the portal since we are only using ParentGroupName to specify target group and not ParentGroupId
#
#   Example CSV:
#   parent_folder,name,description,properties
#   "portalname","Locations","All Resources",""
#   "Locations","NA","North America Resources","snmp.community=na-snmp"
#   "Locations","EURO","Europe Resources","snmp.community=euro-snmp"
#   "Locations","APAC","Asia Pacific Resources","snmp.community=apac-snmp"
#
$csvPath = "path/to/import.csv"
$groups = Import-Csv -Path $csvPath
foreach($group in $groups){
    #Break properties into hashtable
    $properties = @{}
    $groups.properties.Split(",") | ConvertFrom-StringData | ForEach-Object {$properties += $_}

    #Create new device group in LM
    New-LMDeviceGroup -Name $group.name -ParentGroupName $group.parent_folder -Description $group.description -properties $properties
}
```

#### Export list of VM instances discovered for a vcenter resource and output inventory report

```powershell
$Device = Get-LMDevice -DisplayName "vcenter01.villardi.local"
$DataSource = Get-LMDeviceDatasourceList -id $Device.id | Where-Object {$_.dataSourceName -eq "VMware_vCenter_VMPerformance"}
$Instances = Get-LMDeviceDatasourceInstance -DatasourceId $Datasource.datasourceId -DeviceId $Device.id

$Results = @()
Foreach ($VM in $Instances){
    $Results += [PSCustomObject]@{
        VirtualMachine = $VM.name.split("VMware_vCenter_VMPerformance-")[1]
        Host = $VM.autoProperties[$VM.autoProperties.name.IndexOf("auto.runtime.host")].value
        Cluster = $VM.autoProperties[$VM.autoProperties.name.IndexOf("auto.cluster")].value
        NumOfCPUs = $VM.autoProperties[$VM.autoProperties.name.IndexOf("auto.hardware.num_cpu")].value
        NumOfCoresPerSocket = $VM.autoProperties[$VM.autoProperties.name.IndexOf("auto.hardware.num_cores_per_socket")].value
        MemoryMb = $VM.autoProperties[$VM.autoProperties.name.IndexOf("auto.hardware.memory_mb")].value
        MemoryGb = $VM.autoProperties[$VM.autoProperties.name.IndexOf("auto.hardware.memory_mb")].value / 1024
        GuestOS = $VM.autoProperties[$VM.autoProperties.name.IndexOf("auto.guest.guest_os_full_name")].value
    }
}

$Results
```

#### Set instance properties for a network device to override port speed
```powershell
#Get device details by hostname value
$Device = Get-LMDevice -Name "192.168.1.4"

#Pull datasource and instance details
$DataSource = Get-LMDeviceDatasourceList -id $Device.id | Where-Object {$_.dataSourceName -eq "SNMP_Network_Interfaces"}
$Instances = Get-LMDeviceDatasourceInstance -DatasourceId $Datasource.datasourceId -DeviceId $Device.id

#Find instance needing to be updated
$eth0 = $Instances | Where-Object {$_.name -like "*eth0*"}

#Update instance with required props
Set-LMDeviceDatasourceInstance -DeviceId $Device.id -DatasourceId $DataSource.datasourceid -InstanceId $eth0.id -Properties @{"out_speed"=25;"in_speed"=500}
```

#### Remove a group of devices from a device group but do not delete them from LM

```powershell
#Id of group you want to purge devices from
$groupId = (Get-LMDeviceGroup -Name "Group Name").id

If($groupId){
    #Get list of devices inside group we are clearing out
    $devices = Get-LMDeviceGroupDevices -Id $groupId

    #Loop through device list and remove device from $groupId
    foreach($device in $devices){
        #Take existing HostGroupId list and filter out the group we wish to remove the device from
        $newHostGroupIdList = ($device.hostGroupIds -split (",") | ? {$_ -ne "$groupId"}) -join ","

        #Update our device with the new HostGroupId list
        Set-LMDevice -Id $device.id -HostGroupIds $newHostGroupIdList
    }
}
```

#### Bulk trigger Active Discovery for a group of devices

```powershell
#Method One
#Using Get-LMDeviceGroupDevices to trigger AD on a folder called Eastbridge
$deviceGroupId = (Get-LMDeviceGroup -Name "Eastbridge").id
Get-LMDeviceGroupDevices -Id $deviceGroupId | Foreach-Object {Invoke-LMActiveDiscovery -Id $_.id}

#Method Two
#Using Get-LMDevice to get a filtered list of devices to trigger AD against
Get-LMDevice -Name "lm*" | Foreach-Object {Invoke-LMActiveDiscovery -Id $_.id}

#Method Three
#Using the parameter in the Invoke-LMActiveDiscovery to trigger AD on a folder called Eastbridge
Invoke-LMActiveDiscovery -GroupName "Eastbridge"
```

#### Rename devices based on value of a given property

```powershell
#Method One
#Using Get-LMDeviceProperty to retrieve the value for sysname and Set-LMDevice to set the new displayName for it
$deviceProperty = (Get-LMDeviceProperty -Name "192.168.1.1" -Filter "name -eq 'system.sysname'").value
Set-LMDevice -Name "192.168.1.1" -DisplayName $deviceProperty

#Method Two
#Using Get-LMDevice to retrieve the value for sysname and Set-LMDevice to set the new displayName
$device = Get-LMDevice -Name "192.168.1.1"
$deviceProperty = ($device.systemProperties[$device.systemProperties.name.IndexOf("system.sysname")].value)
Set-LMDevice -Name "192.168.1.1" -DisplayName $deviceProperty

#Method Three
#Using Get-LMDeviceGroupDevices to retrieve a list of devices and loop through each and set the sysname value to the displayname
$devices = Get-LMDeviceGroupDevices -Name "Cambium Wireless"
foreach ($dev in $devices) {
    $deviceProperty = ($dev.systemProperties[$dev.systemProperties.name.IndexOf("system.sysname")].value)
    if($deviceProperty -and $dev.systemProperties.name.IndexOf("system.sysname") -ne -1){
        Set-LMDevice -Id $dev.id -DisplayName $deviceProperty
    }
}
```

#### Update/Add device property if out of date or missing
```powershell
#Array to store returned objects
$processedDeviceList = @()

#Get list of devices in a device group for device group id 23
$devices = Get-LMDeviceGroupDevices -Id "23"

#Loop through each device and check for presence of property
foreach ($dev in $devices) {
    $propName = "test.prop"
    $propValue = "1234"
    $currentPropValue = ($dev.customProperties[$dev.customProperties.name.IndexOf($propName)].value)
    if($currentPropValue -and $dev.customProperties.name.IndexOf($propName) -ne -1){

        If($currentPropValue -ne $propValue){
            #Update the property value since it does not match desired value
            $processedDeviceList += Set-LMDevice -Id $dev.id -Properties @{$propName=$propValue}
            Write-Host "Successfully processed $($dev.displayName), updated property $propName value from $currentPropValue -> $propValue"
        }
        Else{
            #Skip device since it already has desired value:
            Write-Host "Skipped processing $($dev.displayName) since property $propName is already present with the desired value $propValue"
        }
    }
    else{
        #Add property and value since it does not exist on device currently
        $processedDeviceList += Set-LMDevice -Id $dev.id -Properties @{$propName=$propValue}
        Write-Host "Successfully processed $($dev.displayName), added property $propName with value $propValue"
    }
}

#Print out results
$processedDeviceList | Select-Object id,displayname,customproperties | Format-List
```

#### Export LM Device Metric Data to JSON/CSV

```powershell
#Method One: Export all datasources and instances by deviceId
Export-LMDeviceData -DeviceId 3 -ExportPath "../../../Desktop" -ExportFormat json

#Method Two: Export only datasources starting with Collector to CSV
Export-LMDeviceData -DeviceId 3 -ExportPath "../../../Desktop" -ExportFormat csv -DatasourceIncludeFilter "Collector*"

#Method Three: Get HTTPS-443 instance metric data for the past 8 hours
Get-LMDeviceData -DeviceId 3 -DatasourceId 72 -InstanceName "443" -StartDate (Get-Date).AddHours(-8) -EndDate (Get-Date)
```

#### Import list of PingMulti instances
``` powershell
#Example adding ping multi via csv with headers DisplayName,Wildvalue,Description
$pingList = Import-CSV ../../../Desktop/test.csv
$device = Get-LMDevice -DisplayName "lmstevenvillardi-wincol02"
$pingMultiId = (Get-LMDeviceDatasourceList -Id $device.Id | Where-Object {$_.dataSourceName -eq "PingMulti-"}).dataSourceId

Foreach($line in $pingList){
    New-LMDeviceDatasourceInstance -DisplayName $line.DisplayName -WildValue $line.Wildvalue -Description $line.Description -DatasourceId $pingMultiId -Id $device.id
}
```

#### Remove a category from system.categories
```powershell
$CategoryToRemove = "test"

$Devices = Get-LMDevice
Foreach($Device in $Devices){
    $Categories = $Device.customproperties.value[$Device.customProperties.name.IndexOf("system.categories")]

    If($Categories -and ($Categories -Split (",")).toLower().Contains($CategoryToRemove.toLower())){
        Try{
            $UpdatedCategories = ($Categories -Split (",") | Where-Object {$_ -ne $CategoryToRemove}) -Join ","    
            Set-LMDevice -Id $Device.Id -Properties @{"system.categories"=$UpdatedCategories}

            Write-Host "Successfully updated device system.properties to remove category ($CategoryToRemove)" -ForegroundColor Green
        }
        Catch{
            Write-Host "Unable to update device: $_" -ForegroundColor Red
        }
    }
    Else{
        Write-Host "Skipping device update, no matching systemcategories value found matching: $CategoryToRemove"
    }
}
```

#### Update a set of datapoints on a datasource
```powershell
$datapoints = $(Get-LMDatasource -id 458).datapoints
$datapoints[1].alertExpr = "> 80 90 95"
Set-LMDatasource -id 458 -Datapoints $datapoints
```

#### Import list of UNC path instances
``` powershell
#Example adding UNC Path monitoring via csv with headers DisplayName,Wildvalue,Description
$uncPathList = Import-CSV ../../../Desktop/test.csv
$device = Get-LMDevice -DisplayName "lmstevenvillardi-wincol02"
$uncMonitorId = (Get-LMDeviceDatasourceList -Id $device.Id | Where-Object {$_.dataSourceName -eq "UNC Monitor-"}).dataSourceId

Foreach($line in $uncPathList){
    New-LMDeviceDatasourceInstance -DisplayName $line.DisplayName -WildValue $line.Wildvalue -Description $line.Description -DatasourceId $uncMonitorId -Id $device.id
}
```
#### Export a set of device configurations and search for a specified regex/string
```powershell
Export-LMDeviceConfigBackup -DeviceGroupId 654 | Search-LMDeviceConfigBackup -SearchPattern "snmp"
```

#### Export a set of device configurations to CSV
```powershell
Export-LMDeviceConfigBackup -DeviceGroupId 654 -Path device-configs.csv
```

#### Ingest PushMetrics 
###### Note: PushMetrics must be enabled for the LM Portal
```powershell
#Example hashtable format for datapoints
$Datapoints =@{
    ErrorCount = 0
    NewUsersCreated = 0
    NewUsersCreatedAsDisabled = 0
    UsersRemovedFromGroups = 0
    UsersWithGroupMembershipChanges = 0
    DomainUsersUpdatedSinceLastSynchronization = 0
    DisabledUsers = 0
    StartDateError = 0
    NextSynchronizationDateTimeError = 0
}
#Create PushMetric datapoint object using hashtable
$DatapointsObject = New-LMPushMetricDataPoint -DataPoints $Datapoints

#Create instance object using datapoint object from previous command
$InstanceObj = New-LMPushMetricInstance -Datapoints $DatapointsObject -InstanceName "Test" -InstanceDisplayName "Test Description"

#Send PushMetric to LM using the instance object created in the previous command along with the specified datasource and resource mapping parameters
Send-LMPushMetric -Instances $InstanceObj -DatasourceName "My_First_Push_Metric" -DatasourceDisplayName "My First Push Metric" -ResourceIds @{"system.displayname"="LM-COLL"}

```