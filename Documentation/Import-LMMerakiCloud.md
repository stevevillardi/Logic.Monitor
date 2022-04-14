---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMMerakiCloud

## SYNOPSIS
Imports a Meraki Cloud portal into LM.

## SYNTAX

### Import (Default)
```
Import-LMMerakiCloud -MerakiAPIToken <String> [-AllowedOrgIds <String[]>] [-AllowedNetworkIds <String[]>]
 [-MerakiRootFolderName <String>] [-MerakiFolderParentGroupId <Int32>] [-CollectorId <String>]
 [<CommonParameters>]
```

### List
```
Import-LMMerakiCloud -MerakiAPIToken <String> [-ListOrgIds] [-ListNetworkIds] [<CommonParameters>]
```

## DESCRIPTION
Imports a Meraki Cloud portal into LM along with creating any required groups and device properties.

## EXAMPLES

### EXAMPLE 1
```
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxxxxxxxxxxxxxxx" -MerakiRootFolderName "Meraki Devices" -CollectorId 1 -MerakiFolderParentGroupId 1
```

### EXAMPLE 2
```
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxxxxxxxxxxxxxxx" -AllowedOrgIds @(1235,6234)
```

## PARAMETERS

### -MerakiAPIToken
Meraki Dashboard API Token

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedOrgIds
Array of Org Ids that you would like to import, if omitted all Org Ids will be imported

```yaml
Type: String[]
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedNetworkIds
Array of Network Ids that you would like to import, if omitted all NetworkIds Ids will be imported

```yaml
Type: String[]
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MerakiRootFolderName
The main folder name for the Meraki import, if omitted the default name is Meraki

```yaml
Type: String
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: Meraki
Accept pipeline input: False
Accept wildcard characters: False
```

### -MerakiFolderParentGroupId
The parent group id that the root meraki device group should exist under, if omitted will default to root of resource tree

```yaml
Type: Int32
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorId
The collector id number to assign to created devices, if omitted devices will be assigned the first collector returned from Get-LMCollector

```yaml
Type: String
Parameter Sets: Import
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListOrgIds
List out the available org ids for a given Meraki Portal.
Useful if you want to use the AllowedOrgIds filter but dont know the id/names of the orgs

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListNetworkIds
{{ Fill ListNetworkIds Description }}

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES
Currently a beta command, meraki cloud import is still under developement, please report any bugs you encounter while using this command.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

