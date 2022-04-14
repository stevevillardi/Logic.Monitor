## Invoke-LMDeviceDedupe

Sometimes Netscans are ran without proper credentials which can lead to devices being added multiple times in a portal. This can be a pain to try and untangle in larger environments as the device count becomes to much to cleanup by hand. This utility will attempt to report and delete duplicate devices within on LM portal. It does so by comparing the syste.ips and system.sysname properties of devices in LM to determine if a device has one or more duplicates. The command will also try to figure out which duplicate is the orginal device by comapring the createdOn date.

##### Parameters

- **ListDuplicates:** Report any potential duplicates but do not take any action. This is recomended before running RemoveDuplicates so you can verify output before making any changes.

- **RemoveDuplicates:** Removes any detected duplicate devices from the portal. Deleted devices still go to the recently deleted bin in LM.

- **DeviceGroupId:** Limits the command to only check devices in a specfic device group. Does not includes subgroups

- **IPExclusionList:** List of IPs to exclude from comparison, includes Ipv4/Ipv6 loopback addresses by default

- **SysNameExclusionList:** List of SysName values to exclude from comparison. Excludes none,n/a,(none),blank,empty and "" by default

### Examples:

```powershell
#List duplicates and export to csv
Invoke-LMDeviceDedupe -ListDuplicates | Export-CSV -Path duplicate.csv -NoTypeInformation

#Remove Duplicates
Invoke-LMDeviceDedupe -RemoveDuplicates

#List duplicates for devices in device groupid 8 to console
Invoke-LMDeviceDedupe -ListDuplicates -DeviceGroupId 8

#List duplicates and exclude certain ips and sysnames from comparison
Invoke-LMDeviceDedupe -ListDuplicates -IPExclusionList @("192.168.1.1","1.1.1.1") SysNameExclusionList @("server-name")
```
