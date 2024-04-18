---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollectorVersions

## SYNOPSIS
Retrieves the versions of LogicMonitor collectors available for download.

## SYNTAX

### All (Default)
```
Get-LMCollectorVersions [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMCollectorVersions [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Top
```
Get-LMCollectorVersions [-TopVersions] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollectorVersions function retrieves the versions of LogicMonitor collectors based on the specified parameters.
It requires a valid API authentication and authorization.

## EXAMPLES

### EXAMPLE 1
```
Get-LMCollectorVersions -Filter "name=Collector1"
```

This example retrieves the collector versions that have the name "Collector1".

### EXAMPLE 2
```
Get-LMCollectorVersions -TopVersions
```

This example retrieves only the top versions of collector versions.

### EXAMPLE 3
```
Get-LMCollectorVersions -BatchSize 500
```

This example retrieves the collector versions in batches of 500.

## PARAMETERS

### -Filter
Specifies the filter to apply when retrieving collector versions.
Only collector versions that match the specified filter will be returned.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TopVersions
Indicates whether to retrieve only the top versions of collector versions.

```yaml
Type: SwitchParameter
Parameter Sets: Top
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
Specifies the number of collector versions to retrieve in each batch.
The default value is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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

### None. You cannot pipe objects to Get-LMCollectorVersions.
## OUTPUTS

### System.Object
### Returns an object that contains the retrieved collector versions.
## NOTES

## RELATED LINKS
