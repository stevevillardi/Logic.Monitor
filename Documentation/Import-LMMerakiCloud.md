## Import-LMMerakiCloud

The existing NetScan script that we provide today does an ok job at importing Meraki resources but fails to address a number of issues when it comes to setup, multi org support and other quality of life improvements. This import command addresses a number of these shortcomings in addition to streamlining the process of adding in a meraki portal into LM.

Enhancemnts over the existing Netscan process today:

- Auto creates the Meraki root folder in the LM portal.

- Ability to list out OrgIds if you need to gather a set of OrgIds to limit import of Meraki Organizations.

- For each Meraki Org it will create a dynamic group set to all networks and org devices with the same meraki.org.id property value.

- Set all existing meraki props needed for device discovery.

- Collect SNMP settings directly from the Meraki API and auto apply them to the Meraki Org dynamic groups.

**Note:** For SNMP v3 the customer will still need to specify the auth and priv token property values as those are not returned via API.

## Parameters

- **MerakiAPIToken:** Merkai API token to use for import.

- **AllowedOrgIds:** Array of OrgIds to limit import to.

- **AllowedNetworkIds:** Array of NetworkIds to limit import to. Can be unsed with AllowedOrdIds

- **MerakiRootFolderName:** Name of the Meraki Root folder in LM. Will default to Meraki if not specified.

- **MerakiFolderParentGroupId:** The folder id to create the meraki device group in. If not specified, the root of the resource tree is used.

- **CollectorId:** The collector id to assign to the network and org devices created during import. If not specified the first collector detected will be used.

- **ListOrgIds:** List out available orgIds and orgNames. Useful if you want to see what organizations are present so you can limit import.

- **ListNetworkIds:** List out available networkIds and networkNames. Useful if you want to see what networks/organizations are present so you can limit import.

This import utility is an ongoing devlopment. If you have things you would like added to this utility let me know.

### Examples:

```powershell
#Import meraki under resource group called Meraki SaaS
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxx" -MerakiRootFolderName "Meraki SaaS"

#Connect to Meraki and dump list of Orgs
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxx" -ListOrgIds

#Import Meraki orgId 12345678 and ignore any other org detected
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxx" -AllowedOrgIds @(12345678)

#Connect to Meraki and dump list of Networks along with thier associated Org
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxx" -ListNetworkIds

#Import Meraki networkId N_12345678 from orgId 12345678 and ignore any other networks detected
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxx" -AllowedNetworkIds @("N_12345678") -AllowedOrgIds @(12345678)
```
