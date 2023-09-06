# Previous module release notes
## 4.4
###### New Features:
**Get-LMDevice**: Support for Delta API. Although not currently enabled in most portals, when enabled it will allow you to get a delta id returned with your query that you can use for up to 30 minutes to retrieve changed resources. This is helpful when making changes to a number of devices and just getting a returned list of devices that have been updated. New parameters -Delta and -DeltaId have been added for this functionality. This is a beta feature and will be improved upon once the feature is GA.

###### New Commands:
**Get-LMUnmonitoredDevice**: New command to retrieve device listings for resource located in unmonitored devices.

**Set-LMUnmonitoredDevice**: New command to move devices from unmonitored devices into required resource groups.

**Remove-LMUnmonitoredDevice**: New command to delete devices from the unmonitored device list.

**Invoke-LMUserLogoff**: New command to end a user session in the LM portal. Parameter -Usernames takes and array of usernames to logoff the portal. SSO users are bound by their sso settings.

###### Update Commands:
**Initialize-LMPOVSetup**: Added checks for dasboard import to skip attempting import if a dashboard is already present.

**New/Set-LMWebsite**: Seperated out Wbecheck and Pingcheck parameter sets to make it easier to see which parameters are required for each type of check. Also added a parameter *-WebsiteSteps* that takes an array of steps to include in new or existing webchecks. See the step schema for how this object should be constructed. 

```
https://www.logicmonitor.com/swagger-ui-master/api-v3/lm-sdkv3-docs.html#api-Websites-addWebsite
```

###### Bug Fixes/Updates:
**Set-LMUser**: Fixed bug that prevented setting boolean flags to false.

## 4.3.1|2
###### Bug Fixes/Updates:
**Initialize-LMPOVSetup**: Fixed bug that prevented -IncludeDefaults from being ran independently.

**Import-LMDashboard**: Added -File parameter to allow for import of a dashboard using raw contents (Get-Content) which is useful if your pulling from a repo and want to send the raw file without saving it to disk first.

## 4.3
###### New Commands:
**New/Set/Remove-LMAppliesToFunction**: Added Create,Update and Delete commands for AppliesToFunctions.

**Set-LMCollectorConfig**: Added command to make bulk config changes for each of the supported collector configs (agent,wrapper,website,sbproxy and watchdog) in addition to changing collector sizes. Also added in support for modifying common config changes like timeouts, threadpool, lmlogs and netflow parameters. Any collector that is targeted with this command will be restart upon config update in order to apply the updated configuration so use caution when using this command.

## 4.2.1
###### Update Commands/Bug Fixes:
**Search-LMDeviceConfigBackup**: Fix issue loading previous release on windows due to encoding bug in Search-LMDeviceConfigBackup
**Invoke-LMDeviceDedupe**: Added support for exluding certain device types from dedupe processing, by default K8s resources are excluded.

## 4.2
###### Feature Updates:
**Improved Filter functionality**: The -Filter parameter has been overhauled to provide more options and flexibility in generating more complex server side filtering options. Previously -Filter only took in a hashtable of properties to perform an equal comparison against, this was very limited compared to the additional filtering options available in LM APIv3. As a result of the update you can now use the following operators when construction the filter string. Additionally the old hashtable method of filtering is still supported for backwards compatibility but may be removed in a future update:

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

**Field names**: Field names in the LM API are case sensitive, ensure you use the proper casing when creating a custom filter (ex displayName). Using incorrect casing can result in unexpected results being returned. Also reference LM APIv3 swagger guide for details on which fields are support for filtering

Additional Filter Examples:
```powershell
#Device Hostname contains UDM and aleting is disabled
Get-LMDevice -Filter "disableAlerting -eq '$true' -and name -contains 'UDM'"

#User email address either contains steve or is null
Get-LMUser -Filter "email -contains 'steve' -or email -ne '$null'"

#Get active alerts where the instance name is Kubernetes_Scheduler and the Alert Rule is labeled Critical
Get-LMAlert -Filter "instanceName -eq 'Kubernetes_Scheduler' -and rule -eq 'Critical'"
```


###### Update Commands/Bug Fixes:
- **Initalize-LMPOVSetup**: Added additional switch **-IncludeDefaults** that adds some additional configuration changes common in POV. By default these changes are not included with the **-RunAll** switch so it needs to be specified in addition to **-RunAll** if you want them included in the setup process:
  - Change alert threshold defaults for SSL_Certificates to only alert for non self signed certs out of box.
  - Import the following LogicModules:
      - Microsoft_Windows_Services_AD (DS)
      - LogicMonitor_Collector_Configurations (CS)
      - NoData_Metrics (DS)
      - NoData_Tasks_By_Type_v2 (DS)
      - NoData_Tasks_Overall_v2 (DS)
      - NoData_Tasks_Discovery_v2 (PS)
- **Set-LMDatasource**: Fix regression bug preventing use of -AppliesTo parameter.

###### New Commands:
 - The following commands have been added in this release, see documentaiton for usage details:
    - **Get-LMNetscanGroup**
    - **Set-LMNetscanGroup**
    - **Remove-LMNetscanGroup**
    - **New-LMNetscanGroup**
    - **Set-LMCollectorGroup**
    - **Remove-LMCollectorGroup**
    - **New-LMCollectorGroup**

## 4.1.1
###### Update Commands/Bug Fixes:
- **Initalize-LMPOVSetup**: Fixed LM Logs datasource issue with importing an older core module that has collection issues. If you are using the POV setup command make sure you use this updated version for all new POVs. For existing POVs to ensure you have the latest core module for Logs either manually update the datasource using the LM Exchange/Repository or by running the bellow command:

```powershell
Import-LMRepositoryLogicModules -Type datasources -LogicModuleNames Windows_Events_LMLogs
```

## 4.1
###### New Commands:
- **Search-LMDeviceConfigBackup**: Performs a search against the output of *Export-LMDeviceConfigBackup* for any line in configurations matching the specified regex pattern. See example documentation for usage.
- **Export-LMDeviceConfigBackup**: Export the latest configuration data for a single or group of devices and export to CSV. Output can also be piped to perform as search against the result set.

###### Update Commands/Bug Fixes:
- **Get-LMAuditLog**: Fixed bug that ignored start and end date filters when trying to search by date range.
- **Set-LMDatasource**: Add new parameter *-Datapoints* that takes an array of datapoints. See example documentation for usage.
- **New-LMRole**: Added new setting permissions values for manage-collectors and view-collectors.
- **Set-LMRole**: Added new setting permissions values for manage-collectors and view-collectors.
- **Initalize-LMPOVSetup**: Added provisioning of lm_container user for use with LM Container. Fixed retry logic for Service Insight creation. Updated minimal monitoring applpiesto criteria.
- **Import-LMRepositoryLogicModules**: Updated command to align with the removal of the core version from the server parameter that was made in portal version 185. Enabled pipeline processing from Get-LMRepositoryLogicModules.
- **Get-LMRepositoryLogicModules**: Updated command to align with the removal of the core version from the server parameter that was made in portal version 185.
- **Get-LMDeviceConfigSourceData**: Added *-ConfigType* parameter to allow you to pull Delta or Full configuration data. Also added *-LatestConfigOnly* switch to only return the more recent configuration backup for the selected devices.
- **Get-LMAuditLogs**: Fixed bug that caused start and end dates to be ignored when performing search.
- **Export-LMDeviceConfigReport**: Updated command to support the changes from *Get-LMDeviceConfigSourceData* and improved console logging.

## 4.0.3
###### Update Commands/Bug Fixes:
- **Initialize-LMPOVSetup**: Added two new switches *-ReadOnlyMode* and *-RevertReadOnlyMode* that will convert and revert all non api accounts to/from readonly mode.
- **Initialize-LMPOVSetup**: Added a new switch *-SetupCollectorServiceInsight* that will provision a service insight example aggregating important collector metrics accross all installed collectors in a portal. This example will be expanded on in future releases.
- **Import-LMLogicModule**: Added new *-File* switch that allows for providing a XML file object directly as opposed to just a FilePath previously.
- **New-LMDevice**: Added support for -*DeviceType* to allow for setting the device type when provisioning a new resource, useful for creating service resources.

## 4.0.2
###### Update Commands/Bug Fixes:
- Fixed **Set-LMCollector** bug causing automatic upgrade schedules to get reset when updating the collector
- Updated **Export-LMDeviceConfigReport** to allow a bunch more filter options. You can now override the default ConfigSourceName and InstanceName filters that were previosuly used by setting the paramerters *-ConfigSourceNameFilter* and *-InstanceNameFilter* to a regex pattern you want to match against. You can no also limit the scope of the report to a single device or a group of devices.

## 4.0.1
###### Module Updates:
- Fix scope bug on Connect-LMAccount cmdlet
- Added support for **Bearer Token** authenticaiton when running Connect-LMAccount and New-LMCachedAccount

###### Update Commands/Bug Fixes:
- **Initialize-LMPOVSetup**: Updated LM Logs datasource to use the latest core version 1.2 when setting up logs.
- **New-LMCachedAccount**: Added new **CachedAccountName** parameter to allow storing of multiple crednetials for the same portal, it is optional and will default to the **AccountName** value if not specified.
- **Get/Remove-LMCachedAccount**: Updated use the new parameter **CachedAccountName** as the required paramerter instead of **AccountName**.
- **Get-LMOpsNotes**: Updated the **Name** parameter to **Tag** to allow for retrival of ops notes by tag since Name is not relevant.

## 4.0
###### Module Updates:
- Automated build and release pipelines have been created to streamline the build and release process.
- Pester testing framework has been created and will be added to throughout future versions to improve testing code coverage
- All previous release notes have been migrated to a seperate release notes page. Going forward only current release notes will be present on the main page.

###### Update Commands/Bug Fixes:
- **Set-LMUser**: Added new parameter *-NewUsername* to allow for updating the username property, previously there was a bug in the parameter sets that did not allow you to update the username.
- **New-LMWebsiteGroup**: Removed unnecessary parameter *-AppliesTo*.
- **New-LMWebsite**: Split out parameter sets for pingcheck and webchecks to make it easier to see which properties are required depending on what type of check you are creating. Also split out the parameter *-Hostname* to be *-PingAddress* or *-WebsiteAddress* depending on which type of check you are creating.
- **Initialize-LMPOVSetup**: Updated website creation to utilize new *-WebsiteAddress* parameter when calling **New-LMWebsite**.
- **Get-LMWebsiteProperty**: Fixed bug that did not require the *-Name* parameter as mandatory if querying by resource name.

## 3.9.3
###### Update Commands/Bug Fixes:
- **New-LMAlertAck**: Downgrade api version used from v4 to v3.
- **New-LMAlertNote**: Downgrade api version used from v4 to v3.
- **Get-LMCollectorDebugResult**: Fixed returned data to just return the command output
- **Invoke-LMCollectorDebugCommand**: Fixed bug that caused session id to not be returned when not running the command with the -IncludeResult switch set.
- **Get-LMNetscan**: Added custom object type to returned Netscan objects
- **Initialize-LMPOVSetup**: Fixed an issue causing setup of lm logs to not properly assign the correct appliesTo logic to the imported Windows Logs DS.
- **New/Set-LMOpsNote**: Updated parameter set to allow for specifying device, website and device group scopes together when modifying or creating an opts note.

###### New Commands:
- **Get-LMNetscanExecution**: Get list of executions for a specified NetScan policy.
- **Get-LMNetscanExecutionDevices**: Get list of devices discovered by a executed netscan policy for a given execution.

###### Removed Commands:
- **Get-LMLogAnomolies** - Removed due to API v4 restrictions
- **Get-LMLogMessage** - Removed due to API v4 restrictions
- **Get-LMLogsAlertPipeline** - Removed due to API v4 restrictions

## 3.9.2
###### Updated Commands:
- **Additional Pipeline Support**: Added pipeline support for the following modules:
  - Get-LMDeviceGroupAlerts
  - Get-LMDeviceAlertSettings
  - Get-LMDeviceAlerts
  - Export-LMLogicModule

- **Import-LMMerakiCloud**: Added an additional parameter *-ListSNMPInfo* to return the configured SNMP org settings for the provided API key. Also added in logic to skip orgs and networks that do not have the dashboard api enabled from being processed.

###### Bug Fixes:
- **Pipeline Support Fix**: Fixed an issue with the following modules that caused pipeline processing to only process the last object passed to it:
  - Remove-LMAPIToken
  - Remove-LMCachedAccount
  - Remove-LMDashboard
  - Remove-LMDashboardGroup
  - Remove-LMDashboardWidget
  - Remove-LMDatasource
  - Remove-LMDeviceProperty
  - Remove-LMNetscan
  - Remove-LMWebsite
  - Set-LMAPIToken
  - Set-LMDeviceDatasourceInstance
  - Set-LMDeviceProperty
  - Set-LMOpsNotes
  - Set-LMWebsite

## 3.9.1
###### Updated Commands:

- **Support for Pipeline input**: All Set-LM* and Remove-LM* can now accept pipeline input from their respective Get-LM* commands! This means you no longer have to pipe output to Foreach-Object in order to loop through the results, you can simply pipe straight to the desired Set/Remove command and specify any additional parameters you need.

Example:
```powershell
#Get set of devices that start with lm and update their description
Get-LMDevice -Name LM* | Set-LMDevice -Description "LogicMontior Collectors"
```

- **Added additional custom object types**: Updated the list of object types that have a custom output format for easier reading. You will see that many objects now display up to 6 values by default but the full response is available when using Select-Object * or referencing the value by name.

- **Outdated Module Pre-Check**: When connecting to an LM account the module will now attempt to verify that you are running the latest version of the PS Module and warn you if a newer version is available for update.

- **Get-LMApiToken**: Added -Id as a new parameter to return a specific api token.

- **Get/Set/Remove-LMDeviceDatasourceInstance**: Update parameter names for device id and device name to $DeviceId and $DeviceName in order to support pipeline processing and standarize parameter naming scheme.

###### Bug Fixes:
- **Get-LMOpsNote**: Fixed a typo that caused Get-LMOpsNote to not be available during module install. You can now use this command as intended.



## 3.9
###### New Commands: 
- **New-LMRole**: Added command to create new User roles within LM. This command accepts a PSCustomObject parameter *CustomPrivledgesObject* as a precreated privledge object for more advanced permission requirements but also has built in parameters to accomodate simipler permission requirements.

- **Set-LMRole**: Added command to create new User roles within LM. This command accepts a PSCustomObject parameter *CustomPrivledgesObject* as a precreated privledge object for more advanced permission requirements but also has built in parameters to accomodate simipler permission requirements.

- **Set-LMDatasource**: Added command to update datasources with a number of parameters. This command will be expanded on in future released but currently support modifying the following properties:
  - Name
  - DisplayName
  - AppliesTo
  - Description
  - Tech Notes
  - Polling Interval

###### Updated Commands: 
- **Multiple Commands**: Added custom object types to returned objects to control the default properties printed to console and to in preparation for accepting pipeline input in a future release.
  -  Get-LMCollector
  -  Set-LMCollector
  -  New-LMCollector
  -  Get-LMDevice
  -  Set-LMDevice
  -  New-LMDevice
  -  Get-LMDashboard
  -  Get-LMDashboardGroup
  -  Get-LMDeviceGroup
  -  Set-LMDeviceGroup
  -  New-LMDeviceGroup
  -  Get-LMWebsite
  -  Set-LMWebsite
  -  New-LMWebsite
  -  Get-LMWebsiteGroup
  -  Set-LMWebsiteGroup
  -  New-LMWebsiteGroup
  -  Get-LMUser
  -  Set-LMUser
  -  New-LMUser
  -  Get-LMRole
  -  Set-LMRole
  -  New-LMRole
  -  Get-LMAPIToken
  -  Set-LMAPIToken
  -  New-LMAPIToken
  -  Get-LMDatasourceAssocaitedDevices
  -  Get-LMDeviceGroupDevices

- **Get-LMRepositoryLogicModule**: CoreVersion no longer is an optional parameter and must be included in the parameter set when running.

- **New-LMDevice**: Added parameter -AutoBalancedCollectorGroupId for specifying an autobalance collector group as the prefered collector group. Use PerferredCollectorId of 0 when using this parameter.

- **Get-LMAPIToken**: Added type parameter that accepts the value of LMv1 or Bearer to return the specified API token to return. Default value of this parameter is LMv1

- **New-LMAPIToken**: Added type parameter that accepts the value of LMv1 or Bearer to create the specified API token in the correct type. Default value of this parameter is LMv1

- **Import-LMDashboard**: When using the parameter --ReplaceAPITokensOnImport the command will now generate a new lm api token per run and auto create an lm_dynamic_dashboards user and custom role with the required minimal permissions. Previously this command would leverage the logged in users api info which is not always ideal.

- **Initalize-LMPOVSetup**: When using the parameter -SetupWindowsLMLogs or -RunAll the command will provision a purpose built user/role called lm-logs-ingest along with the required minimal permissons needed. In addition it the default name of the api user created for portal metrics has been renamed to lm_portal_metrics, previously is was lm_api. In addition, the Windows Logs datasource has also been updated to use the new core module along with setting the appropriate appliesTo logic.

###### Bug Fixes: 
 - **Initalize-LMPOVSetup** : Fixed issue when running dynamic group cleanup and lm logs setup when duplicate folders exist for default devices by type resource groups.

 - **Set-LMWebsiteGroup** : Fixed issue causing parameter set to not be resolved correctly when not specifying ParentGroupId or ParentGroupName parameters

- **Set-LMApiToken**: Fixed issue that caused updating an api token to fail when specifying a -Username parameter instead of -UserId.


## 3.8.1
###### Updated Commands:
- **Get-CollectorInstaller**: Added support for XL and XXL collector sizes and removed legacy support for 32-bit collector variants
- **Import-LMMerakiCloud**: Fixed issue with ListNetworkIds parameter not listing all NetworkIds if it encountered an issue enumerator any organization associated with the specified API key.
- **Initialize-LMPOVSetup**: Remove Log tracked query folder deletion code since it is not longer valid. Added in creation of 16 new dynamic groups that are provisioned as part of the CleanupDynamicGroups parameter. 

New groups include:
```powershell
"All Devices" = 'true()'
"AWS Resources" = 'isAWSService()'
"Azure Resources" = 'isAzureService()'
"GCP Resources" = 'isGCPService()'
"K8s Resources" = 'system.devicetype == "8"'
"Dead Devices" = 'system.hoststatus == "dead" || system.hoststatus == "dead-collector" || system.gcp.status == "TERMINATED" || system.azure.status == "PowerState/stopped" || system.aws.stateName == "terminated"'
"Palo Alto" = 'hasCategory("PaloAlto")'
"Cisco ASA" = 'hasCategory("CiscoASA")'
"Logs Enabled Devices" = 'hasPushModules("LogUsage")'
"Netflow Enabled Devices" = 'isNetflow()'
"Cisco UCS" = 'hasCategory("CiscoUCSFabricInterconnect") || hasCategory("CiscoUCSManager")'
"Oracle" = 'hasCategory("OracleDB")'
"Domain Controllers" = 'hasCategory("MicrosoftDomainController")'
"Exchange Servers" = 'hasCategory("MSExchange")'
"IIS" = 'hasCategory("MicrosoftIIS")'
"Citrix XenApp" = 'hasCategory("CitrixBrokerActive") || hasCategory("CitrixMonitorServiceV2") || hasCategory("CitrixLicense") || hasCategory("CitrixEUEM")'
```

 ###### New Commands:
- **Invoke-LMCloudGroupNetScan**: This command invokes re-discovery of a specified cloud device group. This allows for manually kickoff of new cloud resource discovery.

## 3.8
###### Updated Commands:
- **Connect-LMAccount**
- **New-LMCachedAccount**
- **Get-LMCachedAccount**
- **Remove-LMCachedAccount**

**NOTE**: This update removes the legacy cached account mechanism in favor of **Microsoft's SecretManagement** module. This allows for a much more secure way of storing and retrieving cached API credentials then the legacy method.

If you are using the old cached account method the upgrade process will happen automatically when you connect to an LM portal using the -UseCachedAccount or -CachedAccountName parameters within the Connect-LMAccount command or when using New-CachedAccount to provision a new cached account. If its your first time using SecretManagement you will be prompted to set up a password for accessing your cached accounts in the LocalVault.

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
