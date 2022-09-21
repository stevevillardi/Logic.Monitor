# General

Windows PowerShell module for accessing the LogicMonitor REST API.

NOTE:This is a personal project and is not an offically supported LogicMonitor integration.

This project is also published in the PowerShell Gallery at https://www.powershellgallery.com/packages/Logic.Monitor/.

# Installation

- From PowerShell Gallery:

```powershell
Install-Module -Name "Logic.Monitor"
```

# Upgrading

- New releases are published often, to ensure you have the latest version you can run:

```powershell
Update-Module -Name "Logic.Monitor"
```

# General Usage

Before you can use on module commands you will need to be connected to a LM portal. To connect your LM portal use the **Connect-LMAccount** command:

```powershell
Connect-LMAccount -AccessId "lm_access_id" -AccessKey "lm_access_key" -AccountName "lm_portal_prefix_name"
```

Once connected you can then run an appropriate command, a full list of commands available can be found using:

```powershell
Get-Command -Module "Logic.Monitor"
```

To disconnect from an account simply run the Disconnect-LMAccount command:

```powershell
Disconnect-LMAccount
```

To cache credentials for multiple portals you can use the command New-LMCachedAccount, once a credential has been cached you can reference it when connecting to an lm portal using the -UserCachedCredentials switch in Connect-LMAccount.

```powershell
New-LMCachedAccount -AccessId "lm_access_id" -AccessKey "lm_access_key" -AccountName "lm_portal_prefix_name"
Connect-LMAccount -UseCachedCredential

#Example output when using cached credentials
#Selection Number | Portal Name
#0) portalname
#1) portalnamesandbox
#Enter the number for the cached credential you wish to use: 1
#Connected to LM portal portalnamesandbox using account
```

# Examples

Most Get commands can pull info by id or name to allow for easier retrevial without needing to know the specific resource id. The name paramters in get commands can also accept wildcard values. All responses will return objects in list view so for readablility you may want to pipe the output to **Format-Table**.

Get list of devices:

```powershell
#Get all devices
Get-LMDevice

#Get device via id
Get-LMDevice -Id 1

#Get device via hostname
Get-LMDevice -Name device.example.com

#Get device via displayname/wildcard
Get-LMDevice -DisplayName "corp*"
```

When modifying or removing a device you can use the Name paramter instead of id but wildcard values cannot be used.

Modify a device:

```powershell
#Change device Name,DisplayName,Descrition,Link and set collector assignment
Set-LMDevice -Id 1 -DisplayName "New Device Name" -NewName "device.example.com" -Description "Critical Device" -Link "http://device.example.com" -PreferredCollectorId 1

#Add/Update custom properties to a resource and disable alerting
Set-LMDevice -Id 1 -Properties @{propname1="value1";propname2="value2"} -DisableAlerting $true
```

Remove a device:

```powershell
#Remove device by hostname
Remove-LMDevice -Name "device.example.com" -HardDelete $false

```

Send LM Log Message:

```powershell
Send-LMLogMessage -Message "Hello World!" -resourceMapping @{"system.displayname"="LM-COLL"} -Metadata @{"extra-data"="value";"extra-data2"="value2"}
```

Get LM Log Message:

```powershell
Get-LMLogMessage -Range 1month -Query "error text"
```

Add a new user to LogicMonitor:
```powershell
New-LMUser -RoleNames @("administrator") -Password "changeme" -FirstName John -LastName Doe -Email jdoe@example.com -Username jdoe@example.com -ForcePasswordChange $true -Phone "5558675309"
```

Generate new API Token:
```powershell
New-LMAPIToken -Username jdoe@example.com -Note "Used for K8s"
```

# Code Snipets:

#### Get last 24 hours of alerts and group by resource and datapoint

```powershell
Get-LMAlert -StartDate $(Get-Date).AddDays(-1) -EndDate $(Get-Date) -ClearedAlerts $true | Group-Object -Property resourceTemplateName,datapointName | select count, @{N='Name';E={$_.Name.Split(",")[0]}}, @{N='Datapoint';E={$_.Name.Split(",")[1]}} | Sort-Object -Property count -Descending
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
$deviceProperty = (Get-LMDeviceProperty -Name "192.168.1.1" -Filter @{name="system.sysname"}).value
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

**Note:** Using the Name parameter to target a resource during a Set/Remove command will perform an initial get request for you automatically to retreive the required id. When performing a large amount of changes using id is the prefered method to avoid excesive lookups and avoid any potential API throttling.

**Additional Note:** Currently cmdlets do not support reciving input directly from the pipeline (**Get-LMDevice | Set-LMDevice**). If you need to make modifications use Foreach-Object to loop through the pipeline input (**Get-LMDevice | Foreach-Object {Set-LMDevice $\_.Id}**). I am working on building out custom PSObject types to enable this ability in the future.

# Available Commands

#### Account Connectivity

- Connect-LMAccount
- Disconnect-LMAccount
- New-LMCachedAccount
- Get-LMCachedAccount
- Remove-LMCachedAccount

#### Actuve Discovery

- Invoke-LMActiveDiscovery

#### Alerts

- Get-LMAlert
- New-LMAlertAck
- New-LMAlertNote

#### Alert Rules

- Get-LMAlertRule

#### API Tokens

- Get-LMAPIToken
- New-LMAPIToken
- Set-LMAPIToken
- Remove-LMAPIToken

#### AplliesTo

- Get-LMAppliesToFunction

#### Audit Logs

- Get-LMAuditLogs

#### Collector

- Get-LMCollector
- Get-LMCollectorGroup
- Get-LMCollectorInstaller
- Get-LMCollectorVersion
- New-LMCollector
- Set-LMCollector

#### Collector Debug

- Get-LMCollectorDebugResult
- Invoke-LMCollectorDebugCommand

#### Dashboards

- Get-LMDashboard
- Get-LMDashboardGroup
- Get-LMDashboardWidget
- Remove-LMDashboard
- Remove-LMDashboardGroup
- Remove-LMDashboardWidget
- Import-LMDashboard
- New-LMDashboardGroup

#### Datasources/LogicModules

- Get-LMDatasource
- Get-LMDatasourceAssociatedDevices
- Get-LMDatasourceUpdateHistory
- Get-LMDatasourceMetadata
- Remove-LMDatasource
- Get-LMEventSource
- Get-LMPropertySource
- Get-LMTopologySource
- Get-LMConfigSource
- Export-LMLogicModule
- Import-LMLogicModule
- Import-LMExchangeModule

#### Devices

- Get-LMDevice
- Get-LMDeviceSDT
- Get-LMDeviceSDTHistory
- Get-LMDeviceProperty
- Get-LMDeviceAlerts
- Get-LMDeviceData
- Get-LMDeviceDatasourceInstance
- Get-LMDeviceDatasourceInstanceGroup
- Get-LMDeviceDatasourceInstanceAlertSettings
- Get-LMDeviceDatasourceList
- Get-LMDeviceEventsourceList
- Get-LMDeviceInstanceList
- New-LMDevice
- New-LMDeviceDatasourceInstance
- New-LMDeviceDatasourceInstanceGroup
- Set-LMDeviceDatasourceInstance
- New-LMDeviceProperty
- Set-LMDevice
- Set-LMDeviceProperty
- Remove-LMDevice
- Remove-LMDeviceDatasourceInstance
- Remove-DeviceProperty
- Export-LMDeviceData
- Invoke-LMDeviceConfigSourceCollection

#### Device Groups

- Get-LMDeviceGroup
- Get-LMDeviceGroupSDT
- Get-LMDeviceGroupSDTHistory
- Get-LMDeviceGroupAlerts
- Get-LMDeviceGroupDevices
- Get-LMDeviceGroupGroups
- Get-LMDeviceGroupProperty
- New-LMDeviceGroup
- New-LMDeviceGroupProperty
- Set-LMDeviceGroup
- Remove-LMDeviceGroup

#### Escalation Chain

- Get-LMEscalationChain

#### LM Logs

- Send-LMLogMessage
- Get-LMLogMessage
- Get-LMLogsAlertPipeline

#### Netscan

- Get-LMNetscan
- New-LMNetscan
- Set-LMNetscan
- Remove-LMNetscan
- Invoke-LMNetscan
- Get-LMUnmonitoredDevices

#### Ops Notes

- Get-LMOpsNote
- New-LMOpsNote
- Set-LMOpsNote
- Remove-LMOpsNote

#### Portal Info

- Get-LMPortalInfo
- Get-LMUsageMetrics
- Set-LMPortalInfo

#### Push Metrics (Ingest API)
- New-LMPushMetricDataPoint
- New-LMPushMetricInstance
- Send-LMPushMetric

#### Recipient Group

- Get-LMRecipientGroup

#### Reports

- Get-LMReport
- Get-LMReportGroup

#### Repository (LogicModules)

- Get-LMRepositoryLogicModules
- Import-LMRepositoryLogicModules

#### Topology (Beta)

- Get-LMTopologyMap
- Get-LMTopologyMapData
- Export-LMTopologyMap

#### Users and Roles

- Get-LMRole
- Get-LMUser
- Get-LMUserGroup
- New-LMUser
- New-LMApiUser
- Set-LMUser
- Remove-LMUser
- Remove-LMRole

#### Websites

- Get-LMWebsite
- Get-LMWebsiteAlerts
- Get-LMWebsiteCheckPoint
- Get-LMWebsiteData
- Get-LMWebsiteProperty
- Get-LMWebsiteSDT
- Get-LMWebsiteSDTHistory
- New-LMWebsite
- Set-LMWebsite
- Remove-LMWebsite

#### Website Groups

- Get-LMWebsiteGroup
- Get-LMWebsiteGroupAlerts
- Get-LMWebsiteGroupSDT
- Get-LMWebsiteGroupSDTHistory
- New-LMWebsiteGroup
- Set-LMWebsiteGroup
- Remove-LMWebsiteGroup

#### Utilities (Beta)

- ConvertTo-LMDynamicGroupFromCategories
- Export-LMDeviceConfigReport
- Initialize-LMPOVSetup
- Import-LMMerakiCloud
- Invoke-LMDeviceDedupe

# Change List

## 3.8
###### Updated Commands:
- **Connect-LMAccount**
- **New-LMCachedAccount**
- **Get-LMCachedAccount**
- **Remove-LMCachedAccount**

**NOTE**: This update removes the legacy cached account mechanism in favor of **Microsoft's SecretManagement** module. This allows for a much more secure way of storing and retrieving cached API credentials then the legacy method.

If you are using the old cached account method the upgrade process will happen automatically when you connect to an LM portal using the -UseCachedAccount or -CachedAccountName parameters within the Connect-LMAccount command or when using New-CachedAccount to provision a new cached account

## 3.7.3
###### Bug Fixes:
- **Import-LMMerakiCloud**: Fixed issue that prevented networks with tags applied from getting created during import
- **New-LMNetScan**: Fixed typo in parameter IgnoreSystemIpDuplicates
- **Initialize-LMPOVSetup**: Fixed LogTrackedQuery error when attemping to move Log Tracked Query folder to devices by type
###### Updated Commands:
- **Get-LMDeviceProperty**: Added parameter **PropertyName** to allow for querying a single device property for a device
- **Export-LMDeviceData**: Added parameter **DeviceDisplayName** and **DeviceHostName** to allow either field to be specific for export. Removed previous parameter DeviceName
- **Get-LMDeviceConfigSourceDiff**: Added parameter **ConfigId** to allow a specific config id to be returned vs a list of available configs

## 3.7.2
###### Bug Fixes:
- **Connect-LMAccount**: Fixed issue that prevented api tokens with limited access permissions from connecting successfully.
- Re-factored exception handling that prevented default -ErrorAction parameters from working as expected
- **Set-LMWebsiteGroup**: Fixed an issue with the defined parameter sets that prevented the command from being used in certain parameter combinations

## 3.7.1
###### Updated Documentation:
-  [Module Documentation](https://github.com/stevevillardi/Logic.Monitor/tree/main/Documentation) is now available for all cmdlets. This section will continue to be enhanced through future releases along with more examples

###### Bug Fixes:
- **New-LMPushMetricDataPoint**: Fixed an issue that was caused when providing a PSCustomObject instead of a hashtable as the input parameter for *-DataPoints*. The command now requires a hashtable which is inline with the rest of the module.
## 3.7

###### New Commands:
- **New-LMDashboardGroup**: You can now create dashboard groups along with setting any appropriate widget tokens
- **Remove-LMRole**: You can now remove roles by name or id.
- **Remove-LMDashboardGroup**: You can now remove dashboard groups by name or id.
- **Import-LMDashboard**: You can now import dashboards from a number of sources (.json file, file directory or github repo). If using a github repo or file directory and folder structure detected will be replicated as Dashboard Groups within LM. You can also optionally replace any api id/key widget tokens with the use of the *-ReplaceAPITokensOnImport* parameter. This is useful when importing dynmaic dashboards that expect apiID and apiKey tokens set on them.
- **New-LMPushMetricDataPoint**: You can now create datapoint objects easily for use with the *Send-LMPushMetric* command. This command can be used to build a single datapoint or supplied an existing datapoint object to add additional datapoints to. See the Documentaiton section for list of parameters and examples.
- **New-LMPushMetricInstance**: You can now create instance objects easily for use with the *Send-LMPushMetric* command. This command can be used to build a single instance or supplied an existing instance object to add additional instances to. See the Documentaiton section for list of parameters and examples.
- **Send-LMPushMetric**: You can now send push metrics directly to LM. This command takes in an instances object created by the *New-LMPushMetricInstance* command. See the Documentaiton section for list of parameters and examples.
###### Updated Commands:
- **Get-LMAlert**: Added *-CustomColumns* parameter to allow custom/system properties to be returned in the GET response. This parameter can only be used when specifying a specific *-Id* as the the parameter is not supported by the LM APIv3 when querying for multiple alerts. *-CustomColumns* takes an array of properties.
- **Connect-LMAccount**: Added *-CachedAccountName* parameter to allow bypassing the displaying of all cached accounts when using the *-UseCachedAccount* parameter.
###### Bug Fixes:
- **Get-LMDeviceConfigSourceDiff**: Reduced the default batch size from 1000 to 100 which was causing issues in certain circumstances. *-BatchSize* can still be specified if a custom batch size is required.
- **Get-LMDeviceGroup**: Fixed error handling when unable to find a matching parentId/parentName
- **Disconnect-LMAccount**: Fixed bug introduced by Write-LMHost that caused successful logouts to not produce any confirmation output.
- **All Commands**: Previously LMAuth tokens where stored as Global scoped variables. In version 3.7 and later all LMAuth tokens are now stored as Module scoped to prevent access outside of the Logic.Monitor module.
###### Updated Documentation:
- All publsihed modules are now packaged as releases in Github
## 3.6.5

- Updated commands (**New-LMAlertAck** & **New-LMAlertNote**) due to LM APIv4 endpoint changes to the data model for alerts. You must be on module 3.6.5 or later in order to properly use these commands.

## 3.6.4

- Fixed issue with Import-LMMerakiCloud command that caused meraki org device group creation to fail if meraki org name matched lm portal name
- New Command (**Invoke-LMDeviceConfigSourceCollection**): Trigger a collection for a specified instance of a ConfigSource
- New Command (**Get-LMLogsAlertPipeline**): Get list of configured alert pipelines and associated alert definitions

## 3.6.3

- Fixed issue with Import-LMMerakiCloud command that caused meraki org device groups to be created without an applies to statement when using snmp v3
- Minor bug fixes to Send-LMLogMessage and Initialize-LMPOVSetup

## 3.6.2

- Update console logging behavior. When connecting to an LM account through **Connect-LMAccount** you can now set a switch parameter **-DisableConsoleLogging** to disable any informational console messages. This is useful if you are using the LM PS module inside of an LM datasource and you want to limit what is written to console. By default the module will still log to console for informational messages which was the previous behavior.

## 3.6.1

- New Command (**Get-LMDeviceData**): List an instances metric data for a given time range.
- New Beta Command (**Export-LMDeviceData**): Exports a device/device group's datasource metric data for a given range. Can be exported to JSON/CSV or directly to console as a PSCustomObject. Due to the nature of the LM API depending on how many instances/datasources you have to export this process could take quite a bit of time since each instance has to be pulled seperately. If you want to track the progress of the export use the **-Debug** parameter when running otherwise no output will be display will executing.
- New Commands (**Get/New-LMDeviceDatasourceInstanceGroup**): List and Create datasource instance groups for datasources applied to resources.
- Updated Command: (**Set-LMDeviceDatasourceInstance**): Updated command to allow for setting instance group membership.
- Updated Command: (**Initialize-LMPOVSetup**): Switched imported LM Exchange datasource to use Kevin Ford's imporved metadata LM Logs datasource and set to appropriate lm logs device properties
- Updated Command: (**Import-LMMerakiCloud**): Added logic checks to skip trying to add meraki orgs/networks where dashboard api access has not been enabled. Fixed a bug that would result in no output when trying to list Network/Org ids with and invalid API key.

## 3.6

- New Beta Command (**Invoke-LMDeviceDedupe**): List and Remove potential device duplicates based on matching system.ips and system.sysname values. Useful for clearing up NetScans ran with improper credentials
- Fixed erroneous return output with **Connect-LMAccount** in certain situations
- New Command (**Set-LMCollector**): Modify collector settings typically available under the collector manage UI menu.

## 3.5.1

- Update Beta Command (**Import-LMMerakiCloud**): added system.categories NoPing and NoHTTPS to network and org devices to reduce false positive alerts when adding large networks. Also sanatised names of org and network devices to ensure invalid names are not added to the portal. Added additonal parameters for **-AllowedNetworkIds** and **-ListNetworkIds** to allow for futher import filtering.
- New Command (**Get-LMDatasourceMetadata**): This command will pull locator info for datasources that are published.
- New Command (**Import-LMExchangeModule**): This command will import a given LM exchange module via provided exchange module guid.
- Updated Command (**Initialize-LMPOVSetup**): Add support to allow automatic setup of LM Logs datasource for automated windows event logs ingestion.
- Updated Command (**Invoke-LMCollectorDebugCommand**): Add support for groovy and posh command types in addition the default collector debug commands. Also added parameters to specfiy wildcard and hostname values when test groovy/ps scripts
- Added a new **Documentation** section to provide additonal usage info on specific utility modules.

## 3.5

- Remove all unused request loops when expecting a single API response.
- Fix erroneous output when using Set-LMOptsNote and New-LMOpsNote, leftover from debug testing.
- Moved all non id parameter lookups into private function called **Test-LookupResult** for easier support in the future.
- Updated Command (**Export-LMDeviceConfigReport**): This command will not default to 7 days back if not specified and a Switch has been added (-OpenOnCompletetion) that if set will auto open the report in the browser once completed. This use to be the default behavior but is now an optional setting.
- New Beta Command (**Import-LMMerakiCloud**): This command will connect to a meraki cloud portal and import all orgs and networks into logic monitor. Replaces the need to use the LM Netscan script for Meraki device import.

## 3.4.2

- Fixed bug with **Initialize-LMPOVSetup** that could cause portal metrics resource creation to fail if company displayname is changed before running POV setp
- Fixed issue with **Initialize-LMPOVSetup** where lm_api user or portal metrics resource will attemp to be provisioned if it already exists.
- New Command (**New-LMOpsNote**): This command will create a new OpsNote within the LM Portal. If no resource/group scopes are use the note will be created for the entire portal.
- New Command (**Remove-LMOpsNote**): This command will delete any specified OpsNote id from the LM Portal.
- New Command (**Set-LMOpsNote**): This command will update any specified OpsNote id from the LM Portal.
- New Command (**Remove-LMNetscan**): This command will delete any specified netscan from the LM Portal.
- New Command (**Set-PortalInfo**): This command will change various portal settings (update whitelist settings,enable remote session, require 2fa, set user session timeout, portal displayname, etc)

## 3.4.1

- Added **DisplayName** parameter to **Get-LMDeviceProperty** command.
- Fixed `hastable must contain hashtable` error with **Send-LMLogMessage** when not submiting metadata with your message payload
- Added **MessageArray** parameter to **Send-LMLogMessage** to allow for passing an array of hashtables containing multiple messages to submit at once instead of having to send them one at a time. Bulk ingest limit is currently 8MB per request.

## 3.4

- Bug Fixes:
  - Fixed Error output for API endpoint returning LM API v4 responses.
- New Command (**Send-LMLogMessage**): This command will submit a log message to LM Logs.
- New Command (**Get-LMLogMessage**): This command will list available LM Logs messages for given time range and query.
- Updated Beta Utility Command (**Initialize-LMPOVSetup**):
  - You can now specify the api user name if needed using the parameter -APIUsername.

## 3.3

- Bug Fixes:
  - Fixed Parameter set issue with **Set-LMDeviceGroup** when not specifying a parentGroupId/Name
  - Fixed missing steps issue when creating a webcheck with **New-LMWebsite**. Currently steps are not customizable via command.
  - Fixed issue with **New-LMUser** updating entries with null values when not specified.
  - Various bug fixes
- New Command (**New-LMAPIUser**): This command can be used to provision an api only user account
- New Command Set (**New-LMNetScan** | **Set-LMNetScan** | **Invoke-LMNetScan**)
- New Beta Utility Command (**ConvertTo-LMDynamicGroupFromCategories**): This command takes paramertes and simply creates a set of dynamic groups under devices by type based on active categories applied to devices in your portal
- New Beta Utility Command (**Export-LMDeviceConfigReport**): This command takes a path and number of days in the past to pull a report of config changes for a given device group id
- New Beta Utility Command (**Initialize-LMPOVSetup**): This command performs some initial cleanup tasks for newly provisioned portals.
- New Beta Command (**Get-LMDeviceConfigSourceDiff**) : This command will query the changed config data for a given device config instance.

## 3.2.4

- Fixed bug when using Set-LMWebsite if SSLThreshold is not specified as a parameter

## 3.2.3

- Added in API throttling/rate limit logic to more gracefully handle API throttling when sending to many requests
- Move error handling logic to its own function
- Fixed Connect-LMAccount when connecting to accounts with an invalid API key
- New Command Set (**Remove-LMWebsiteGroup** | **New-LMWebsiteGroup** | **Set-LMWebsiteGroup**): These commands will allow you to create, modify and delete website groups in the LM portal
- Updated Command **Connect-LMAccount**: You can now choose an account name that has been cached with the New-LMCachedAccount command using the -UseCachedCredential switch parameter
- New Command Set (**New-LMCachedAccount** | **Get-LMCachedAccount** | **Remove-LMCachedAccount**): These commands will allow you to cache a series of account api credentials for different portals to allow for easy switching between mutiple LM portals such as production vs sandbox. Credentials are cached in the current users home directory as encryted secure strings in the file Logic.Monitor.json

## 3.2.2

- Fixed issues with version 5.1 of powershell requiring System.Web assemblies to be loaded before importing LM module. If you are running version 5.1 of PS make sure you are using this version.

## 3.2

- Fixed issue with null responses causing exception when using a custom object type
- Added some additional code snippets to the readme
- New Command **Import-LMRepositoryLogicModules**: This command will import one or more specified datasources, configsources, eventsources, propertysources or topologysources from the LM Repository (Not the LM Exchange)
- New Command **Get-LMRepositoryLogicModules**: This command will list any available datasources, configsources, eventsources, propertysources or topologysources from the LM Repository (Not the LM Exchange)
- New Command **Get-LMDeviceDatasourceInstanceAlertSetting**: This command will list out alert settings for a given device/datasource/instance specified

## 3.1.1

- Fixed issues with Get-LMWebsiteData failing when not specifying a checkpoint id. Commands will now grab first assigned checkpoint if one is not specified
- Added some code snippets to the updated readme

## 3.1

- New Command **New-LMCollector**: This command will create a new collector resource that can be used with **Get-LMCollectorInstaller** to stand up a new collector.
- New Command **Get-LMPortalInfo**: This command will return portal settings info including resource counts and datasource/instance counts
- New Command **Invoke-LMCollectorDebugCommand**: This command will execute a collector debug command against a targeted collector
- New Command **Get-LMCollectorDebugResult**: This command will retrieve the result of a collector debug command task
- New Command **Import-LMLogicModule**: This command will import an xml/json file for an assoicated datasource, eventsource, propertysource or topologysource. Requires PS version 6.1.0 or later to use
- New Command **Export-LMLogicModule**: This command will export an xml/json file for an assoicated datasource, eventsource, propertysource or topologysource
- New Command **Get-LMPropertySource**: This command will get collect info about a property source/s

- Added help documentation for the following commands:

  - Connect-LMAccount
  - Disconnect-LMAccount
  - Get-LMDevice
  - Get-LMDeviceGroup
  - Get-LMWebsite

- Fixed bug with Get-LMDeviceGroupDevices not properly reuturning all nested resources when using the IncludeSubFolders parameter
- Added parameter sets for all \*-LMDeviceDatasourceInstance commands to ensure a resource id/name and datasource id/name are specified when executing.
- Added custom object types to _Get-LMAlert_, _Get-LMAlertRule_ and _Get-LMCollector_ to allow for better default output views. Will be expanding to other commands as time goes on.
- Added custom object type LogicMontior.LogicModule for the _Get-\*\*Source_ commands to allow for better default output views.
- Fixed default output path when using _Get-LMCollectorInstaller_ to use Get-Location instead of $PSScriptRoot which was causing download to default to the module install path instead of the current directory for the PS session.
- Fixed Connect-LMAccount returning the wrong user id associated with the API token being used. Added additional role and resource counts to logged in status response.

## 3.0.7.6

- New Command **New-LMDevice**: This command will allow you to provision new devices into LM, has same options as the previous Set-LMDevice command. Properties can be specified via hastable @{name1="value1";name2="value2} and static group assignment can be set using HostGroupIds paramter as an array @(1,34,67,etc)
- New Command **New-LMDeviceGroupGroups**: This command will return all groups witin the specified device group
- New Command **Get-LMDeviceEventSourceList**: Returns hostEventSources attached to a particular resource. Takes device _Id_ or _Name_ as paramter
- Added [bool]IncludeSubFolders parameter to Get-LMDeviceGroupDevices command to recusvively return all devices under the specified group including subgroups. Set to $false by default.

## 3.0.7.5

- Fixed issue with Set-LMDeviceGroup where parentid 0 was being sent if not specified instead of null.
- Added NewName parameters for Set-LMDevice and Set-LMDeviceGroup commands to allow the rename of the Name field

## 3.0.7.4

- New Command **Invoke-LMActiveDiscovery**
- New Command **Get-LMTopologyMap**
- New Command **Get-LMTopologyMapData**
- New Beta Command **Export-LMTopologyMap**
- New Command **Set-LMDeviceDatasourceInstance**
- New Command **Remove-LMDeviceDatasourceInstance**
- New Command **Get-LMDeviceDatasourceInstance**
- New Command **New-LMDeviceProperty**
- New Command **Set-LMDeviceProperty**
- New Command **Remove-LMDeviceProperty**

-Added helper function Add-ObjectDetail as basis for type casting result objects to allow for eventually accepting pipeline object input for Set and Remove commands

## 3.0.7.3

- New Command **New-LMDeviceDatasourceInstance**

## 3.0.7.2

- Fixed incorrect error message on DELETE method commands

## 3.0.7.1

- Fixed error handling issue with cross compability changes

## 3.0.6.1

- Updated modules to be compatible with powershell version 5.1 an later
- Simplified error handling between different versions of powershell

## 3.0.5.1

- Updated Get-LMAlert and Get-LMAuditLogs to work with large number of record returns
- Switched out Invoke-WebRequest for Invoke-RestMethod on all commandlets
- Added **Get-LMWebsiteData** command
- Added helper functions for type casting return objects as ground work for accepting pipeline input and controling default display output

## 3.0.4.1

- Updated Commands to accept pipeline object (Get-LMx | Set-LMx)
  - Updated **(Remove|Get|Set)-LMDevice**
  - Updated **(Remove|Get|Set)-LMDeviceGroup**
  - Updated **(Remove|Get|Set)-LMUser**

## 3.0.3.1

- Added New Commands
  - Added **Remove-LMDevice**
  - Added **Remove-LMDashboard**
  - Added **Remove-LMDashboardWidget**
  - Added **Remove-LMDatasource**
  - Added **Remove-LMWebsite**
  - Added **Set-LMDevice**
  - Added **Set-LMWebsite**

## 3.0.2.1

- Added New Commands
  - Added **Remove-LMAPIToken**
  - Added **Set-LMAPIToken**
  - Added **New-LMDeviceGroup**
  - Added **Remove-LMDeviceGroup**
  - Added **Set-LMDeviceGroup**

## 3.0.1.1

- Get-LM\* Modules
  - Changed the filter parameter in applicable Get-LM* commands to use a hashtable, also added a PropsList array and helper function for URL encoding the filter. Filters can now be formated as such: \*\*-Filter @{name="Steve*";staus="active"}\*\*

## 3.0.1.0

- Added New LMUser Commands
  - Added **New-LMUser**
  - Added **New-LMAPIToken**
  - Added **Set-LMUser**
  - Added **Remove-LMUser**
  - Improved error handling for Http exceptions and added helper function to parse LM API v4 response errors.
