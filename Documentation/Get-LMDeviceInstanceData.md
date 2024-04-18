---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceInstanceData

## SYNOPSIS
Retrieves data for LogicMonitor device instances.

## SYNTAX

```
Get-LMDeviceInstanceData [[-StartDate] <DateTime>] [[-EndDate] <DateTime>] [-Ids] <String[]>
 [[-AggregationType] <String>] [[-Period] <Double>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDeviceInstanceData function retrieves data for LogicMonitor device instances based on the specified parameters.

## EXAMPLES

### EXAMPLE 1
```
Get-LMDeviceInstanceData -StartDate (Get-Date).AddHours(-7) -EndDate (Get-Date) -Ids "12345", "67890" -AggregationType "average" -Period 1
Retrieves data for the device instances with IDs "12345" and "67890" for the past 7 hours, using an average aggregation and a period of 1 day.
```

## PARAMETERS

### -StartDate
The start date for the data retrieval.
If not specified, the function uses the default value of 24 hours ago which is the max timeframe for this endpoint.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
The end date for the data retrieval.
If not specified, the function uses the current date and time.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Ids
The array of device instance IDs for which to retrieve data.
This parameter is mandatory.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AggregationType
The type of aggregation to apply to the retrieved data.
Valid values are "first", "last", "min", "max", "sum", "average", and "none".
The default value is "none".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Period
The period for the data retrieval.
The default value is 1.

```yaml
Type: Double
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 1
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
This function requires a valid LogicMonitor API authentication.
Make sure to log in using Connect-LMAccount before running this command.

## RELATED LINKS
