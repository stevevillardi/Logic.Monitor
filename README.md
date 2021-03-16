# General
Windows PowerShell module for accessing the LogicMonitor REST API.

NOTE:This is a personal project and is not an offically supported LogicMonitor integration.

This project is also published in the PowerShell Gallery at https://www.powershellgallery.com/packages/Logic.Monitor/.

# Installation
- From PowerShell Gallery: 
```powershell
Install-Module -Name "Logic.Monitor"
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

**Note:** Using the Name parameter to target a resource during a Set/Remove command will perform an initial get request for you automatically to retreive the required id. When performing a large amount of changes using id is the prefered method to avoid excesive lookups and avoid any potential API throttling.

# Change List
## 3.0.7.6
- New Command **New-LMDevice**: This command will allow you to provision new devices into LM, has same options as the previous Set-LMDevice command. Properties can be specified via hastable @{name1="value1";name2="value2} and static group assignment can be set using HostGroupIds paramter as an array @(1,34,67,etc)
- New Command **New-LMDeviceGroupGroups**: This command will return all groups witin the specified device group
- New Command **Get-LMDeviceEventSourceList**: Returns hostEventSources attached to a particular resource. Takes device *Id* or *Name* as paramter
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
- Get-LM* Modules
  - Changed the filter parameter in applicable Get-LM* commands to use a hashtable, also added a PropsList array and helper function for URL encoding the filter. Filters can now be formated as such: **-Filter @{name="Steve*";staus="active"}**
## 3.0.1.0
- Added New LMUser Commands
  - Added **New-LMUser**
  - Added **New-LMAPIToken**
  - Added **Set-LMUser**
  - Added **Remove-LMUser**
  - Improved error handling for Http exceptions and added helper function to parse LM API v4 response errors.
