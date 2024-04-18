---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMDeviceData

## SYNOPSIS
Exports device data from Logic Monitor.

## SYNTAX

### DeviceId
```
Export-LMDeviceData -DeviceId <Int32> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceDisplayName
```
Export-LMDeviceData -DeviceDisplayName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceHostName
```
Export-LMDeviceData -DeviceHostName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceGroupId
```
Export-LMDeviceData -DeviceGroupId <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### DeviceGroupName
```
Export-LMDeviceData -DeviceGroupName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Export-LMDeviceData function exports device data from Logic Monitor based on the specified parameters.
It collects data from the specified devices, their datasources, and their instances within a specified time range.
The exported data can be saved in JSON or CSV format.

## EXAMPLES

### EXAMPLE 1
```
Export-LMDeviceData -DeviceId 12345 -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -ExportFormat json -ExportPath "C:\LMData"
```

Exports device data for the device with ID 12345, collecting data for the last 7 days and saving it in JSON format at the specified path.

### EXAMPLE 2
```
Export-LMDeviceData -DeviceGroupName "Production Servers" -StartDate (Get-Date).AddHours(-12) -ExportFormat csv
```

Exports device data for all devices in the "Production Servers" group, collecting data for the last 12 hours and saving it in CSV format at the current location.

## PARAMETERS

### -DeviceId
Specifies the ID of the device to export data for.
This parameter is mutually exclusive with the DeviceDisplayName, DeviceHostName, DeviceGroupId, and DeviceGroupName parameters.

```yaml
Type: Int32
Parameter Sets: DeviceId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceDisplayName
Specifies the display name of the device to export data for.
This parameter is mutually exclusive with the DeviceId, DeviceHostName, DeviceGroupId, and DeviceGroupName parameters.

```yaml
Type: String
Parameter Sets: DeviceDisplayName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceHostName
Specifies the host name of the device to export data for.
This parameter is mutually exclusive with the DeviceId, DeviceDisplayName, DeviceGroupId, and DeviceGroupName parameters.

```yaml
Type: String
Parameter Sets: DeviceHostName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupId
Specifies the ID of the device group to export data for.
This parameter is mutually exclusive with the DeviceId, DeviceDisplayName, DeviceHostName, and DeviceGroupName parameters.

```yaml
Type: String
Parameter Sets: DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupName
Specifies the name of the device group to export data for.
This parameter is mutually exclusive with the DeviceId, DeviceDisplayName, DeviceHostName, and DeviceGroupId parameters.

```yaml
Type: String
Parameter Sets: DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
Specifies the start date and time for the data collection.
By default, it is set to the current date and time minus 1 hour.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date).AddHours(-1)
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Specifies the end date and time for the data collection.
By default, it is set to the current date and time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Date)
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceIncludeFilter
Specifies the filter for including specific datasources.
By default, it includes all datasources.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceExcludeFilter
Specifies the filter for excluding specific datasources.
By default, no datasources are excluded.

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

### -ExportFormat
Specifies the format for exporting the data.
Valid values are "csv", "json", or "none".
By default, it is set to "none".

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

### -ExportPath
Specifies the path where the exported data will be saved.
By default, it is set to the current location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Location).Path
Accept pipeline input: False
Accept wildcard characters: False
```

### -ProgressAction
{{ Fill ProgressAction Description }}

```yaml
Type: ActionPreference
Parameter Sets: (All)
Aliases: proga

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
