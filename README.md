[![Build and Test PSGallery Release](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/main.yml)\
[![Test Current Build](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test.yml)

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

Cached credentials are stored in a LocalVault using **Microsoft's SecretManagement** module. If its your first time using SecretManagement you will be prompted to set up a password for accessing your cached accounts in the LocalVault using this method.

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

Add a new user to LogicMonitor:
```powershell
New-LMUser -RoleNames @("administrator") -Password "changeme" -FirstName John -LastName Doe -Email jdoe@example.com -Username jdoe@example.com -ForcePasswordChange $true -Phone "5558675309"
```

Generate new API Token:
```powershell
New-LMAPIToken -Username jdoe@example.com -Note "Used for K8s"
```

**Note:** Using the Name parameter to target a resource during a Set/Remove command will perform an initial get request for you automatically to retreive the required id. When performing a large amount of changes using id is the prefered method to avoid excesive lookups and avoid any potential API throttling.

# Additional Code Examples and Documentation

- [Code Snippet Library](EXAMPLES.md)
- [Command Documentation](/Documentation)

# Available Commands

#### Account Connectivity

- Connect-LMAccount
- Disconnect-LMAccount
- New-LMCachedAccount
- Get-LMCachedAccount
- Remove-LMCachedAccount*

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
- Set-LMAPIToken*
- Remove-LMAPIToken*

#### AplliesTo

- Get-LMAppliesToFunction
- New-LMAppliesToFunction
- Set-LMAppliesToFunction
- Remove-LMAppliesToFunction

#### Audit/Integration Logs

- Get-LMAuditLogs
- Get-LMIntegrationLogs

#### Collector

- Get-LMCollector
- Get-LMCollectorGroup
- Get-LMCollectorInstaller
- Get-LMCollectorVersion
- New-LMCollector
- Set-LMCollector*
- Set-LMCollectorConfig*
- Set-LMCollectorGroup*
- Remove-LMCollectorGroup*
- New-LMCollectorGroup

#### Collector Debug

- Get-LMCollectorDebugResult
- Invoke-LMCollectorDebugCommand

#### Dashboards

- Get-LMDashboard
- Get-LMDashboardGroup
- Get-LMDashboardWidget
- Remove-LMDashboard*
- Remove-LMDashboardGroup*
- Remove-LMDashboardWidget*
- Import-LMDashboard
- New-LMDashboardGroup

#### Datasources/LogicModules

- Get-LMDatasource
- Get-LMDatasourceGraph
- New-LMDatasourceGraph
- Get-LMDatasourceOverviewGraph
- New-LMDatasourceOverviewGraph
- Set-LMDatasource*
- Get-LMDatasourceAssociatedDevices
- Get-LMDatasourceUpdateHistory
- Get-LMDatasourceMetadata
- Remove-LMDatasource*
- Get-LMEventSource
- Get-LMPropertySource
- Get-LMTopologySource
- Get-LMConfigSource
- Export-LMLogicModule*
- Import-LMLogicModule
- Import-LMExchangeModule

#### Devices

- Get-LMDevice
- Get-LMDeviceSDT
- Get-LMDeviceSDTHistory
- Get-LMDeviceProperty
- Get-LMDeviceAlerts*
- Get-LMDeviceAlertSettings*
- Get-LMDeviceData
- Get-LMDeviceDatasourceInstance
- Get-LMDeviceDatasourceInstanceGroup
- Get-LMDeviceDatasourceInstanceAlertSetting
- Set-LMDeviceDatasourceInstanceAlertSetting
- Get-LMDeviceDatasourceList
- Get-LMDeviceEventsourceList
- Get-LMDeviceInstanceList
- Export-LMDeviceConfigBackup
- Get-LMDeviceConfigSourceData
- New-LMDevice
- New-LMDeviceDatasourceInstance
- New-LMDeviceDatasourceInstanceGroup
- Set-LMDeviceDatasourceInstance*
- New-LMDeviceProperty
- Set-LMDevice*
- Set-LMDeviceProperty*
- Remove-LMDevice*
- Remove-LMDeviceDatasourceInstance*
- Remove-DeviceProperty*
- Export-LMDeviceData
- Invoke-LMDeviceConfigSourceCollection

#### Device Groups

- Get-LMDeviceGroup
- Get-LMDeviceGroupSDT
- Get-LMDeviceGroupSDTHistory
- Get-LMDeviceGroupAlerts*
- Get-LMDeviceGroupDatasourceAlertSetting
- Get-LMDeviceGroupDatasourceList
- Get-LMDeviceGroupDevices
- Get-LMDeviceGroupGroups
- Get-LMDeviceGroupProperty
- New-LMDeviceGroup
- New-LMDeviceGroupProperty
- Set-LMDeviceGroup*
- Set-LMDeviceGroupDatasourceAlertSetting
- Remove-LMDeviceGroup*

#### Escalation Chain

- Get-LMEscalationChain

#### LM Logs

- Send-LMLogMessage

#### Netscan

- Get-LMNetscan
- Get-LMNetscanExecution
- Get-LMNetscanExecutionDevices
- New-LMNetscan
- Set-LMNetscan*
- Remove-LMNetscan*
- Invoke-LMNetscan
- Invoke-LMCloudGroupNetScan
- Get-LMUnmonitoredDevice
- Set-LMUnmonitoredDevice
- Remove-LMUnmonitoredDevice
- Get-LMNetscanGroup
- Set-LMNetscanGroup*
- Remove-LMNetscanGroup*
- New-LMNetscanGroup

#### Ops Notes

- Get-LMOpsNote
- New-LMOpsNote
- Set-LMOpsNote*
- Remove-LMOpsNote*

#### Portal Info

- Get-LMPortalInfo
- Get-LMUsageMetrics
- Set-LMPortalInfo
- Set-LMNewUserMessage

#### Push Metrics (Ingest API)
- New-LMPushMetricDataPoint
- New-LMPushMetricInstance
- Send-LMPushMetric
- Set-LMPushModuleDeviceProperty
- Set-LMPushModuleInstanceProperty

#### Recipient Group

- Get-LMRecipientGroup

#### Reports

- Get-LMReport
- Get-LMReportGroup

#### Repository (LogicModules)

- Get-LMRepositoryLogicModules
- Import-LMRepositoryLogicModules*

#### SDT (Scheduled Down Time)
- Get-LMSDT
- Set-LMSDT*
- Remove-LMSDT*
- New-LMDeviceSDT
- New-LMDeviceGroupSDT
- New-LMDeviceDatasourceSDT
- New-LMDeviceDatasourceInstanceSDT

#### Topology (Beta)

- Get-LMTopologyMap
- Get-LMTopologyMapData

#### Users and Roles

- Get-LMRole
- Get-LMUser
- Get-LMUserGroup
- New-LMUser
- New-LMRole
- New-LMApiUser
- Set-LMUser*
- Set-LMRole*
- Remove-LMUser*
- Remove-LMRole*
- Invoke-LMUserLogoff

#### Websites

- Get-LMWebsite
- Get-LMWebsiteAlerts
- Get-LMWebsiteCheckPoint
- Get-LMWebsiteData
- Get-LMWebsiteProperty
- Get-LMWebsiteSDT
- Get-LMWebsiteSDTHistory
- New-LMWebsite
- Set-LMWebsite*
- Remove-LMWebsite*

#### Website Groups

- Get-LMWebsiteGroup
- Get-LMWebsiteGroupAlerts
- Get-LMWebsiteGroupSDT
- Get-LMWebsiteGroupSDTHistory
- New-LMWebsiteGroup
- Set-LMWebsiteGroup*
- Remove-LMWebsiteGroup*

#### Utilities (Moved to Logic.Monitor.SE module)

- ConvertTo-LMDynamicGroupFromCategories
- Export-LMDeviceConfigReport
- Initialize-LMPOVSetup
- Import-LMMerakiCloud
- Invoke-LMDeviceDedupe
- Build-LMDataModel
- Submit-LMDataModel
- Search-LMDeviceConfigBackup*

***Note**: Supports Pipline Input

# Change List

## 4.6.3
###### Bug Fix:
**Get-LMDeviceData**: Fix parameterset used to lookup HsdId when calling Get-LMDeviceDatasourceInstance.

## 4.6.2
###### New Commands:
**Get-LMDeviceGroupDatasourceAlertSetting**: New cmdlet to retrieve alert settings for datasources associated with resources that are a member of a device group. Useful for looking up datasource ids and datapoint info so you can modify group level alert settings using Set-LMDeviceGroupDatasourceAlertSetting.
**Set-LMDeviceGroupDatasourceAlertSetting**: New cmdlet to set group level alert settings for datasources associated with resources that are a member of a device group. 

**Get-LMDeviceGroupDatasourceList**: New cmdlet to list out datasource info for all datasources assocaited with a specified device group.

**Get-LMDeviceDatasourceInstanceAlertSetting**: New cmdlet to retrieve alert settings for datasources instances associated with a resource. Useful for looking up datasource ids and datapoint info so you can modify device/instance level alert settings using Set-LMDeviceDatasourceInstanceAlertSetting.
**Set-LMDeviceDatasourceInstanceAlertSetting**: New cmdlet to set device/instance level alert settings for datasources associated with a resource. 

###### Example Usage:
**Note:** Below examples use names to reference portal objects. You should use IDs where possible to avoid exsessive look ups when chaning configurations in bulk.
```powershell
#Get list of datasources associated with devices that are a member of the Villa Villardi resource group
Get-LMDeviceGroupDatasourceList -Name "Villa Villardi"

#Get alert seetings for HTTPS datasource at the Villa Villardi resource group level
Get-LMDeviceGroupDatasourceAlertSetting -Name "Villa Villardi" -DatasourceName "HTTPS"

#Disable alerting at the resource group level for the HTTPS -> status datapoint for all resources in Villa Villardi resource group
Set-LMDeviceGroupDatasourceAlertSetting -Name "Villa Villardi" -DatasourceName "HTTPS" -DatapointName Status -DisableAlerting $true

#Get device instance alert settings info for datasource NoData_Tasks_By_Type_v2 where the instance name is ping
Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceName NoData_Tasks_By_Type_v2 -Name 127.0.0.1 -InstanceName ping

#Set device instance alert setting to alert when instance ping has a datapoint named taskCount that has a value > 100 generate a warning
Set-LMDeviceDatasourceInstanceAlertSetting -DatasourceName NoData_Tasks_By_Type_v2 -Name 127.0.0.1 -InstanceName ping -DatapointName taskCount -AlertExpression "> 100"
```
[Previous Release Notes](RELEASENOTES.md)