## Initialize-LMPOVSetup

When starting a new POV there is often a checklist of items that need to be done on everyone. Since these steps often are the same amongst POVs it makes sense to try and automate the process as much as possible. The Initialize-LMPOVSetup command is used to do just that. Below is a list of options you have when running the utility and what is actually done behind the scenes:

- **SetupWebsite:** Creates a External Webcheck using the _Website Default_ settings for any website specific using the parameter **Website**.

- **SetupPortalMetrics:** Generates an API user and token for use with portal metrics, creates a LogicMonitor Portal Metrics dynamic group, creates a customer.logicmonitor.com device and assigns the appropriate properties.

- **MoveMinimalMonitoring:** Moves the _Minimal Monitoring_ folder into _Devices by Type_. Also modifies the AppliesTo query to exclude Meraki and PortalMetrics devices from showing up.

- **CleanUpDynamicGroups:** Deletes the Misc folder and updates the Linux Servers folders AppliesTo to include Linux_SSH devices. Also deploys and additional 15 dynamic groups for various resource types (dead devices, palo alto, aws, gcp, azure, etc)

- **SetupWindowsLMLogs:** Generates a lm_logs api user, imports the LM Logs datasource from the LM Exchange and assigns the required properties to the dynamic group Windows Servers.

- **SetupLMContainer:** Generates and lm_container user and role with required permissions for use with LM Container.

- **SetupCollectorServiceInsight:** Create an example service insight for all collectors in a portal and import required DS from LM Repo.

- **RunAll:** Performs all of the above functions.

- **ReadOnlyMode:** Used by itself to convert a portals users to the readonly role. Excludes lmsupport and api only users. Retains previous role history for rollback

- **RevertReadOnlyMode:** Revert any users effected by the ReadOnlyMode parameter. Useful if you need to re-enable previously converted users from readonly mode.

- **IncludeDefaults:** Additionally include setup of default options, see below for full list of whats included.

### Optional Parameters

- **-Website** : The name of the website to use for webcheck creation (example.com) (*Required when using RunAll parameter*)

- **-WebstieHttpType** : Protocol to use for webcheck (http or https). Defaults to **https** if not specified

- **-PortalMetricsAPIUsername** : The name to use for creation of the API User. Defaults to **lm_api** if not specified.

- **-LogsAPIUsername** : The name to use for creation of the LM Logs API User. Defaults to **lm_logs** if not specified.

- **-LMContainerAPIUsername** : The name to use for creation of the LM Container API User. Defaults to **lm_container** if not specified.

- **-WindowsLMLogsEventChannels**: Comma seperated list of windows event channel to setup for ingestions. Defaults to **Application,System** if not specified.

**Notes:** This utility should be ran after the customer has deployed their first collector so we can corectly provision the portal metrics resource

### IncludeDefaults

- Dynamic Dashboard Auto Deploy: Now included as a default option, this configuration will auto create the following:
    - Auto provision a lm_dynamic_dashboards user and associated role
    - Auto provision an LM API token for the new user
    - Provision a Dashboard Group called Dynamic Dashboards

- Download and Import the current set of dynamic dashboards populated with the generated API token from the following repo: https://github.com/stevevillardi/LogicMonitor-Dashboards MTTR Dashboard and LogicModule setup: As a v1 release this is a nice way to measure MTTR within logicmonitor. We say we help customers lower thier MTTR but many have not way to prove it let alone know what that value even is. This module package is the first step towards allowing our customers to actually track their MTTR and understand areas that need improvement. What actually gets deployed is as follows (see attached screenshot and video for example):
    - Download and Import MTTR dashboard from the following repo: https://github.com/stevevillardi/LogicMonitor-Dashboards (Deplyoed to LogicMonitor Dashboards/LogicMonitor in the LM portal)
    - Download and Import 2 associated datasources:
        - LogicMonitor_Device_Alert_Statistics.xml
        - LogicMonitor_Portal_Alert_Statistics.xml
    - Auto apply the modules to the LM Portal Metrics resource
    Set the MTTR rolling period to 7 days (mttr.period property on Portal Metrics resource)
- Change alert threshold defaults for SSL_Certificates to only alert for non self signed certs out of box.
- Import the following LogicModules:
    - Microsoft_Windows_Services_AD (DS)
    - LogicMonitor_Collector_Configurations (CS)
    - NoData_Metrics (DS)
    - NoData_Tasks_By_Type_v2 (DS)
    - NoData_Tasks_Overall_v2 (DS)
    - NoData_Tasks_Discovery_v2 (PS)

### Examples:

```powershell
#Run all setup steps and add https://example.com as the web check
Initialize-LMPOVSetup -RunAll -Website "example.com"

#Run all setup steps and add https://example.com as the web check along with additional defaults
Initialize-LMPOVSetup -RunAll -IncludeDefaults -Website "example.com"

#Setup just a webcheck for http://example.com
Initialize-LMPOVSetup -SetupWebsite -Website "example.com" -WebstieHttpType "http"

#Setup portal metrics with custom api username
Initialize-LMPOVSetup -SetupPortalMetrics -PortalMetricsAPIUsername "custom_name"

#Setup LM Logs with custom api username
Initialize-LMPOVSetup -SetupWindowsLMLogs -LogsAPIUsername "custom_logs_name"

#Convert a portal to readonly mode
Initialize-LMPOVSetup -ReadOnlyMode

#Revert a portal from readonly mode
Initialize-LMPOVSetup -RevertReadOnlyMode
```
