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

**Note:** Using the Name parameter to target a resource during a Set/Remove command will perform an initial get request for you automatically to retreive the required id. When performing a large amount of changes using id is the prefered method to avoid excesive lookups and avoid any potential API throttling.

# Additional Code Examples and Documentation

- [Code Snippet Library](EXAMPLES.md)
- [Command Documentation](/Documentation)
- [Utilities Documentation](/Documentation/Utilities)

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

#### Audit Logs

- Get-LMAuditLogs

#### Collector

- Get-LMCollector
- Get-LMCollectorGroup
- Get-LMCollectorInstaller
- Get-LMCollectorVersion
- New-LMCollector
- Set-LMCollector*

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
- Get-LMDeviceDatasourceInstanceAlertSettings
- Get-LMDeviceDatasourceList
- Get-LMDeviceEventsourceList
- Get-LMDeviceInstanceList
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
- Get-LMDeviceGroupAlertSettings*
- Get-LMDeviceGroupDevices
- Get-LMDeviceGroupGroups
- Get-LMDeviceGroupProperty
- New-LMDeviceGroup
- New-LMDeviceGroupProperty
- Set-LMDeviceGroup*
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
- Get-LMUnmonitoredDevices

#### Ops Notes

- Get-LMOpsNote
- New-LMOpsNote
- Set-LMOpsNote*
- Remove-LMOpsNote*

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
- New-LMRole
- New-LMApiUser
- Set-LMUser*
- Set-LMRole*
- Remove-LMUser*
- Remove-LMRole*

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

#### Utilities

- ConvertTo-LMDynamicGroupFromCategories
- Export-LMDeviceConfigReport
- Initialize-LMPOVSetup
- Import-LMMerakiCloud
- Invoke-LMDeviceDedupe

***Note**: Supports Pipline Input

# Change List
## 4.0
###### Module Updates:
- Automated build and release pipelines have been created to streamline the build and release process.
- Pester testing framework has been created and will be added to throughout future versions to improve testing code coverage
- All commands will now throw an exception if the assocaited REST call does not come back as a status code 200, previously this was just written to console as an error message.
- All previous release notes have been migrated to a seperate release notes page. Going forward only current release notes will be present on the main page.

###### Update Commands/Bug Fixes:
- **Set-LMUser**: Added new parameter *-NewUsername* to allow for updating the username property, previously there was a bug in the parameter sets that did not allow you to update the username.
- **New-LMWebsiteGroup**: Removed unnecessary parameter *-AppliesTo*.
- **New-LMWebsite**: Split out parameter sets for pingcheck and webchecks to make it easier to see which properties are required depending on what type of check you are creating. Also split out the parameter *-Hostname* to be *-PingAddress* or *-WebsiteAddress* depending on which type of check you are creating.
- **Initialize-LMPOVSetup**: Updated website creation to utilize new *-WebsiteAddress* parameter when calling **New-LMWebsite**.
- **Get-LMWebsiteProperty**: Fixed bug that did not require the *-Name* parameter as mandatory if querying by resource name.

[Previous Release Notes](RELEASENOTES.md)