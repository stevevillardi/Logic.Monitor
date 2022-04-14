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

```
Export-LMDeviceConfigReport [[-DeviceGroupId] <Int32>] [[-DaysBack] <String>] [-Path] <String>
 [-OpenOnCompletetion] [<CommonParameters>]
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
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: 0
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
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OpenOnCompletetion
Open the output htmml report automatically once completed

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

