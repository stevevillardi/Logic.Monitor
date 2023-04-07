---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMDeviceConfigReport

## SYNOPSIS
Exports an HTML report containing changed network configs

## SYNTAX

### Device (Default)
```
Export-LMDeviceConfigReport -DeviceId <Int32> [-InstanceNameFilter <Regex>] [-ConfigSourceNameFilter <Regex>]
 [-DaysBack <String>] -Path <String> [-OpenOnCompletion] [<CommonParameters>]
```

### DeviceGroup
```
Export-LMDeviceConfigReport -DeviceGroupId <Int32> [-InstanceNameFilter <Regex>]
 [-ConfigSourceNameFilter <Regex>] [-DaysBack <String>] -Path <String> [-OpenOnCompletion] [<CommonParameters>]
```

## DESCRIPTION
Export device config change report based on the number of days specified, defaults to using the Devices by Type/Network folder

## EXAMPLES

### EXAMPLE 1
```
Export-LMDeviceConfigReport -DaysBack 30 -DeviceGroupId 2 -Path export-report.html
```

### EXAMPLE 2
```
Export-LMDeviceConfigReport -Path export-report.html -OpenOnCompletetion
```

## PARAMETERS

### -DeviceGroupId
Device group id for the group to use as the source of running the report, defaults to Devices by Type/Network folder if not specified

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

### -DaysBack
Number of days back to run the report, defaults to 7 if not specified

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 7
Accept pipeline input: False
Accept wildcard characters: False
```

### -Path
Path to export the HTML report to

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

### -OpenOnCompletion
Open the output html report automatically once completed

```yaml
Type: SwitchParameter
Parameter Sets: (All)
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
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

