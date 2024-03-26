[![Build PSGallery Release](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/main.yml/badge.svg?event=release)](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/main.yml)\
[![Test Current Build on PowerShell Core](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test.yml)\
[![Test Current Build on Windows Powershell 5.1](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test-win.yml/badge.svg)](https://github.com/stevevillardi/Logic.Monitor/actions/workflows/test-win.yml)

# General

Windows PowerShell module for accessing the LogicMonitor REST API.

NOTE: This is a personal project and is not an offically supported LogicMonitor integration. If an official LM PS module is of interest I suggest entering your feedback within your LM portal so interest can be recored. Any bugs/issues with this module should be reported via a submitted issue within the Logic.Monitor repo along with any feature requests.

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

### **Using the -Filter parameter**: 
The -Filter parameter has been overhauled to provide more options and flexibility in generating more complex server side filtering options. Previously -Filter only took in a hashtable of properties to perform an equal comparison against, this was very limited compared to the additional filtering options available in LM APIv3. As a result of the update **4.2** you can now use the following operators when construction the filter string. Additionally the old hashtable method of filtering is still supported for backwards compatibility but may be removed in a future update:

| Operator      | Description           |
|---------------|-------------          |
|-eq	        |Equal                  |
|-ne            |Not equal              |
|-gt	        |Greater than           |
|-lt	        |Less than              |
|-ge            |Greater than or equal  |
|-le            |Less than or equal     |
|-contains	    |Contain                |
|-notcontains   |Does not contain       |
|-and	        |Comparison *and* operator   |
|-or            |Comparison *or* operator   |

**Notes**: When creating your own custom filters, consider the following items:

**Text values**: Enclose the text in single quotation marks (for example, 'Value' or 'Value with spaces'):

```powershell
-Filter "displayName -eq 'MyNameHere'"
```

**Variables**: Enclose variables that need to be expanded in single quotation marks:

```powershell
-Filter "username -eq '$User'"
```

**Integer values**: You don't need to enclose integers (for example, 500). You can often enclose integers in single quotation marks but is not required:

```powershell
-Filter "id -eq 7"
```

**System values**: Enclose system values (for example, \$true, \$false, or \$null) in single quotation marks:

```powershell
-Filter "disableAlerting -eq '$true'"
```

**Field names**: Field names in the LM API are case sensitive, ensure you use the proper casing when creating a custom filter (ex displayName). Using incorrect casing can result in unexpected results being returned. Also reference LM APIv3 swagger guide for details on which fields are supported for filtering.

Additional Filter Examples:
```powershell
#Device Hostname contains UDM and aleting is disabled
Get-LMDevice -Filter "disableAlerting -eq '$true' -and name -contains 'UDM'"

#User email address either contains steve or is null
Get-LMUser -Filter "email -contains 'steve' -or email -ne '$null'"

#Get active alerts where the instance name is Kubernetes_Scheduler and the Alert Rule is labeled Critical
Get-LMAlert -Filter "instanceName -eq 'Kubernetes_Scheduler' -and rule -eq 'Critical'"
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
- Copy-LMDashboard
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

- Copy-LMDevice
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

- Get-LMDeviceGroup*
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

- Copy-LMReport
- Get-LMReport
- Get-LMReportGroup
- New-LMReportGroup
- Set-LMReportGroup*
- Remove-LMReportGroup*
- Remove-LMReport*

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

## 5.1.3
### Updated Cmdlets:
- **New-LMRole**:
  - Update cmdlet to support provisioning new LMX RBAC permissions.

- **Set-LMRole**:
  - Update cmdlet to support provisioning new LMX RBAC permissions.

- **Invoke-LMActiveDiscovery**:
  - Added pipeline support for device id. You can now pipe results cmdlets that return device objects directly to this command.

[Previous Release Notes](RELEASENOTES.md)
