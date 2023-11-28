[![Build and Test PSGallery Release](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/main.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/main.yml)\
[![Test Current Build](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test.yml)

# General

Windows PowerShell module for accessing the LogicMonitor REST API.

NOTE: This is a personal project and is not an offically supported LogicMonitor integration. If an official LM PS module if of interest I suggest entering your feedback within your LM portal so interest can be recored. Any bugs/issues with this module should be reported via a submitted issue within the Logic.Monitor repo along with any feature requests.

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

**Note:** Using the -Name parameter to target a resource during a Set/Remove command will perform an initial get request for you automatically to retreive the required id. When performing a large amount of changes using id is the prefered method to avoid excesive lookups and avoid any potential API throttling.

# Additional Code Examples and Documentation

- [Code Snippet Library](EXAMPLES.md)
- [Command Documentation](/Documentation)

# Available Commands ( over 168 to date)

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
- Set-LMTopologysource*
- Set-LMPropertysource*
- Set-LMConfigsource*
- Get-LMDatasourceAssociatedDevices
- Get-LMDatasourceUpdateHistory
- Get-LMDatasourceMetadata
- Remove-LMDatasource*
- Remove-LMConfigsource*
- Remove-LMTopologysource*
- Remove-LMPropertysource*
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

***Note**: Supports Pipline Input

# Change List

## 5.0
###### New features/Breaking changes:
**Support for -WhatIf parameter on destructive cmdlets**:
- All destructive cmdlets (*Remove-LM<cmdletName>*) now support the *-WhatIf* parameter to allow for validation of execution without actually deleting anything. With -WhatIf, PowerShell will run your cmdlet in its entirety without executing the actions of the cmdlet so no changes occur. It displays a listing of actions to be performed against the affected objects in the console window. In a subsequent release, support for -WhatIf will be extended to modification cmdlets(Set-LM* | Send-LM*).

```powershell
Get-LMDevice -Id 123  | Remove-LMDevice -WhatIf
# What if: Performing the operation "Remove Device" on target "Id: 123 | Name: 127.0.0.1".
```

**Support for -Confirm parameter on destructive cmdlets**:
- All destructive cmdlets (*Remove-LM<cmdletName>*) now support the -Confirm parameter. The Confirm switch instructs the cmdlet to which it is applied to stop processing before any changes are made. The default value of the Confirm switch is $true when not specified. When true the cmdlet prompts you to acknowledge each action before it continues. When you use the Confirm switch, you can step through changes to objects to make sure that changes are made only to the specific objects that you want to change. This functionality is useful when you apply changes to many objects and want precise control over the operation of the Shell. A confirmation prompt is displayed for each object before the Shell modifies the object. **Note**: Since this is a breaking change please ensure any scripted automations that leverage destructive cmdlets are updated prior to updating to this version. Simply updating any existing removal cmdlets with *-Confirm:$false* is all that is needed to mitigate this new behavior.

```powershell
Get-LMDevice -Id 123  | Remove-LMDevice

# Confirm
# Are you sure you want to perform this action?
# Performing the operation "Remove Device" on target "Id: 123 | Name: 127.0.0.1".
# [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "Y"):
```

**Support for -Debug parameter on all cmdlets**:
- All cmdlets that make REST API calls now support the -Debug parameter. Debug will show all rest calls made during the cmdlet execution along with header and payload details to make troubleshooting easier and to allow for easier viewing of what endpoint are used within each cmdlet.

```powershell
Get-LMDevice -Id 123  -Debug
# DEBUG: Invoked Command: Get-LMDevice
# DEBUG: Bound Parameters: [Id:123] [Debug:True]
# DEBUG: Invoked URL: https://<portal>.logicmonitor.com/santaba/rest/device/devices/123
# DEBUG: Request Headers: [Authorization:LMv1 xxxxxxxx...] [Content-Type:application/json] [X-Version:3]

# id  name      displayName            description currentCollectorId hostStatus
# --  ----      -----------            ----------- ------------------ ----------
# 123 127.0.0.1 lm-coll.villardi.local             8                  NORMAL
```

**Write-LMHost deprecation**:
- Write-LMHost was a helper function introduced early on in this modules development to allow for flexible control when writing to the console. In version 5.0 and later this helper function has been deprecated and will be removed entirely in a future version. Cmdlets that leveraged Write-LMHost has been replaced with native Write-Host and/or Write-Output cmdlets where applicable. Any cmdlets that previously did not produce any output (ex. Removal-LM* and Invoke-LM*) but simply wrote to the console will now return their status as output which can used for validation in scripting or suppressed entirely be redirecting output to Out-Null.

```powershell
Remove-LMDevicedatasourceinstance -deviceid 123 -DatasourceId 37 -Wildvalue $null -Confirm:$false

# InstanceId Message
# ---------- -------
#  106997159 Successfully removed (DeviceId: 123 | DatasourceId: 37 | WildValue: )
```

**Support for clearing values with Set-LMx cmdlets**:
- Historically Set-LMx cmdlets allowed you to modify details about an object but did not allow you to reset/null values that had already been set. Most parameters that accept [String] datatypes will now allow you to pass null values where accetped by the api. Example use case would be removing a description from a resource or a link on a user role.

```powershell
Set-LMDevice -id 123 -Description "hello world"

# id  name      displayName            description currentCollectorId hostStatus
# --  ----      -----------            ----------- ------------------ ----------
# 123 127.0.0.1 lm-coll.villardi.local hello world 8                  NORMAL

Set-LMDevice -id 123 -Description $null

# id  name      displayName            description currentCollectorId hostStatus
# --  ----      -----------            ----------- ------------------ ----------
# 123 127.0.0.1 lm-coll.villardi.local             8                  NORMAL
```

###### New-Cmdlets:
**Remove-LMConfigsource**:
- Support removal of specfied configsources from connected portal.
**Remove-LMPropertysource**:
- Support removal of specfied propertyrules from connected portal.
**Remove-LMTopologysource**:
- Support removal of specfied topologysources from connected portal.

**Set-LMConfigsource**:
- Support modification of specfied configsources from connected portal.
**Set-LMPropertysource**:
- Support modification of specfied propertyrules from connected portal.
**Set-LMTopologysource**:
- Support modification of specfied topologysources from connected portal.

###### Updated-Cmdlets:
**Connect-LMAccount**:
- Added check for new releases of SE modules if installed.
- Added *-AutoUpdateModuleVersion* switch parameter to allow for auto upgrading of installed Logic.Monitor modules if a new version is detected. The default behavior is to simply notify that a new version is available.

[Previous Release Notes](RELEASENOTES.md)