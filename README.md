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
#all devices
Get-LMDevice

#via device id
Get-LMDevice -Id 1

#via device hostname
Get-LMDevice -Name device.example.com

#via device displayname/wildcard
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

Code Snipets:

```powershell
#Example 1:
#Get last 24 hours of alerts and group by resource and datapoint
Get-LMAlert -StartDate $(Get-Date).AddDays(-1) -EndDate $(Get-Date) -ClearedAlerts $true | Group-Object -Property resourceTemplateName,datapointName | select count, @{N='Name';E={$_.Name.Split(",")[0]}}, @{N='Datapoint';E={$_.Name.Split(",")[1]}} | Sort-Object -Property count -Descending

#Example 2:
#Loop through all webchecks and list out SSL remaining days till expiration
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

#Example 3:
#Import new devices from CSV including properties
#
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

#Example 4:
#Import new device groups from CSV including properties
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
    New-LMDeviceGroup -GroupName $group.name -ParentGroupName $group.parent_folder -Description $group.description -properties $properties
}
```

**Note:** Using the Name parameter to target a resource during a Set/Remove command will perform an initial get request for you automatically to retreive the required id. When performing a large amount of changes using id is the prefered method to avoid excesive lookups and avoid any potential API throttling.

# Available Commands

### Account Connectivity

- Connect-LMAccount
- Disconnect-LMAccount
- New-LMCachedAccount
- Get-LMCachedAccount
- Remove-LMCachedAccount

### Actuve Discovery

- Invoke-LMActiveDiscovery

### Alerts

- Get-LMAlert
- New-LMAlertAck
- New-LMAlertNote

### Alert Rules

- Get-LMAlertRule

### API Tokens

- Get-LMAPIToken
- New-LMAPIToken
- Set-LMAPIToken
- Remove-LMAPIToken

### AplliesTo

- Get-LMAppliesToFunction

### Audit Logs

- Get-LMAuditLogs

### Collector

- Get-LMCollector
- Get-LMCollectorGroup
- Get-LMCollectorInstaller
- Get-LMCollectorVersion
- New-LMCollector

### Collector Debug

- Get-LMCollectorDebugResult
- Invoke-LMCollectorDebugCommand

### Dashboards

- Get-LMDashboard
- Get-LMDashboardGroup
- Get-LMDashboardWidget
- Remove-LMDashboard
- Remove-LMDashboardWidget

### Datasources/LogicModules

- Get-LMDatasource
- Get-LMDatasourceAssociatedDevices
- Get-LMDatasourceUpdateHistory
- Remove-LMDatasource
- Get-LMEventSource
- Get-LMPropertySource
- Get-LMTopologySource
- Get-LMConfigSource
- Export-LMLogicModule
- Import-LMLogicModule

### Devices

- Get-LMDevice
- Get-LMDeviceSDT
- Get-LMDeviceSDTHistory
- Get-LMDeviceProperty
- Get-LMDeviceAlerts
- Get-LMDeviceDatasourceInstance
- Get-LMDeviceDatasourceInstanceAlertSettings
- Get-LMDeviceDatasourceList
- Get-LMDeviceEventsourceList
- Get-LMDeviceInstanceList
- New-LMDevice
- New-LMDeviceDatasourceInstance
- Set-LMDeviceDatasourceInstance
- New-LMDeviceProperty
- Set-LMDevice
- Set-LMDeviceProperty
- Remove-LMDevice
- Remove-LMDeviceDatasourceInstance
- Remove-DeviceProperty

### Device Groups

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

### Escalation Chain

- Get-LMEscalationChain

### Netscan

- Get-LMNetscan
- Get-LMUnmonitoredDevices
- New-LMNetscan
- Set-LMNetscan
- Invoke-LMNetscan

### Ops Notes

- Get-LMOpsNotes

### Portal Info

- Get-LMPortalInfo
- Get-LMUsageMetrics

### Recipient Group

- Get-LMRecipientGroup

### Reports

- Get-LMReport
- Get-LMReportGroup

### Repository (LogicModules)

- Get-LMRepositoryLogicModules
- Import-LMRepositoryLogicModules

### Topology (Beta)

- Get-LMTopologyMap
- Get-LMTopologyMapData
- Export-LMTopologyMap

### Users and Roles

- Get-LMRole
- Get-LMUser
- Get-LMUserGroup
- New-LMUser
- New-LMApiUser
- Set-LMUser
- Remove-LMUser

### Websites

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

### Website Groups

- Get-LMWebsiteGroup
- Get-LMWebsiteGroupAlerts
- Get-LMWebsiteGroupSDT
- Get-LMWebsiteGroupSDTHistory
- New-LMWebsiteGroup
- Set-LMWebsiteGroup
- Remove-LMWebsiteGroup

### Utilities (Beta)

- ConvertTo-LMDynamicGroupFromCategories
- Export-LMDeviceConfigReport
- Initialize-LMPOVSetup

# Change List

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
