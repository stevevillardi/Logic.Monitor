---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMDeviceData

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### DeviceId
```
Export-LMDeviceData -DeviceId <Int32> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [<CommonParameters>]
```

### DeviceDisplayName
```
Export-LMDeviceData -DeviceDisplayName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [<CommonParameters>]
```

### DeviceHostName
```
Export-LMDeviceData -DeviceHostName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [<CommonParameters>]
```

### DeviceGroupId
```
Export-LMDeviceData -DeviceGroupId <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [<CommonParameters>]
```

### DeviceGroupName
```
Export-LMDeviceData -DeviceGroupName <String> [-StartDate <DateTime>] [-EndDate <DateTime>]
 [-DatasourceIncludeFilter <String>] [-DatasourceExcludeFilter <String>] [-ExportFormat <String>]
 [-ExportPath <String>] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -DatasourceExcludeFilter
{{ Fill DatasourceExcludeFilter Description }}

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

### -DatasourceIncludeFilter
{{ Fill DatasourceIncludeFilter Description }}

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

### -DeviceDisplayName
{{ Fill DeviceDisplayName Description }}

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

### -DeviceGroupId
{{ Fill DeviceGroupId Description }}

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
{{ Fill DeviceGroupName Description }}

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

### -DeviceHostName
{{ Fill DeviceHostName Description }}

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

### -DeviceId
{{ Fill DeviceId Description }}

```yaml
Type: Int32
Parameter Sets: DeviceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
{{ Fill EndDate Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportFormat
{{ Fill ExportFormat Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: csv, json, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExportPath
{{ Fill ExportPath Description }}

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

### -StartDate
{{ Fill StartDate Description }}

```yaml
Type: DateTime
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
