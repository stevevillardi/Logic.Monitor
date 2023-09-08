---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMDeviceConfigBackup

## SYNOPSIS
Exports the latest version of a device config for a select set of devices

## SYNTAX

### Device (Default)
```
Export-LMDeviceConfigBackup -DeviceId <Int32> [-InstanceNameFilter <Regex>] [-ConfigSourceNameFilter <Regex>]
 [-Path <String>] [<CommonParameters>]
```

### DeviceGroup
```
Export-LMDeviceConfigBackup -DeviceGroupId <Int32> [-InstanceNameFilter <Regex>]
 [-ConfigSourceNameFilter <Regex>] [-Path <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports the latest version of a device config for a select set of devices

## EXAMPLES

### EXAMPLE 1
```
Export-LMDeviceConfigBackup -DeviceGroupId 2 -Path export-report.csv
```

### EXAMPLE 2
```
Export-LMDeviceConfigBackup -DeviceId 1 -Path export-report.csv
```

## PARAMETERS

### -DeviceGroupId
Device group id for the group to use as the source of running the report.

```yaml
Type: Int32
Parameter Sets: DeviceGroup
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
Device id to use as the source of running the report, defaults to Devices by Type/Network folder if not specified

```yaml
Type: Int32
Parameter Sets: Device
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceNameFilter
Regex filter to use to filter out Instance names used for discovery, defaults to "running|current|PaloAlto".

```yaml
Type: Regex
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: [rR]unning|[cC]urrent|[pP]aloAlto
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigSourceNameFilter
Regex filter to use to filter out ConfigSource names used for discovery, defaults to ".*"

```yaml
Type: Regex
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: .*
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to export the csv backup to

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

