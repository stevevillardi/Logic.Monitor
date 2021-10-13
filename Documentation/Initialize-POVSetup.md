## Invoke-LMPOVSetup

When starting a new POV there is often a checklist of items that need to be done on everyone. Since these steps often are the same amongst POVs it makes sense to try and automate the process as much as possible. The Initialize-LMPOVSetup command is used to do just that. Below is a list of options you have when running the utility and what is actually done behind the scenes:

- **SetupWebsite:** Creates a External Webcheck using the _Website Default_ settings for any website specific using the parameter **Website**.

- **SetupPortalMetrics:** Generates an API user and token for use with portal metrics, creates a LogicMonitor Portal Metrics dynamic group, creates a customer.logicmonitor.com device and assigns the appropriate properties.

- **MoveMinimalMonitoring:** Moves the _Minimal Monitoring_ folder into _Devices by Type_. Also modifies the AppliesTo query to exclude Meraki and PortalMetrics devices from showing up.

- **CleanUpDynamicGroups:** Deletes the Misc folder and updates the Linux Servers folders AppliesTo to include Linux_SSH devices.

- **SetupWindowsLMLogs:** Generates a lm_logs api user, imports the LM Logs datasource from the LM Exchange and assigns the required properties to the dynamic group Windows Servers.

- **RunAll:** Performs all of the above functions.

##### Parameters

**-Website** : The name of the website to use for webcheck creation (example.com)
**-WebstieHttpType** : Protocol to use for webcheck (http or https). Defaults to **https** if not specified
**-PortalMetricsAPIUsername** : The name to use for creation of the API User. Defaults to **lm_api** if not specified.
**-LogsAPIUsername** : The name to use for creation of the LM Logs API User. Defaults to **lm_logs** if not specified.

This utility is an ongoing devlopment. If you have things you would like added to this prep utility let me know (customer image upload, upload additonal datasources/dashboards, etc)

**Notes:** This utility should be ran after the customer has deployed their first collector so we can corectly provision the portal metrics resource

### Examples:

```powershell
#Run all setup steps and add https://example.com as the web check
Invoke-LMPOVSetup -RunAll -Website "example.com"

#Setup just a webcheck for http://example.com
Invoke-LMPOVSetup -SetupWebsite -Website "example.com" -WebstieHttpType "http"

#Setup portal metrics with custom api username
Invoke-LMPOVSetup -SetupPortalMetrics -PortalMetricsAPIUsername "custom_name"

#Setup LM Logs with custom api username
Invoke-LMPOVSetup -SetupWindowsLMLogs -LogsAPIUsername "custom_logs_name"
```
