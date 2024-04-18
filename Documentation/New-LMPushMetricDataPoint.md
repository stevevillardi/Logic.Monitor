---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMPushMetricDataPoint

## SYNOPSIS
Creates a new data point object for pushing metric data to LogicMonitor.

## SYNTAX

```
New-LMPushMetricDataPoint [[-DataPointsArray] <System.Collections.Generic.List`1[System.Object]>]
 [-DataPoints] <System.Collections.Generic.List`1[System.Object]> [[-DataPointType] <String>]
 [[-DataPointAggregationType] <String>] [[-PercentileValue] <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMPushMetricDataPoint function creates a new data point object that can be used to push metric data to LogicMonitor.
The function accepts an array of data points, where each data point consists of a name and a value.
The function also allows you to specify the data point type, aggregation type, and percentile value.

## EXAMPLES

### EXAMPLE 1
```
$datapoints = @(
    [PSCustomObject]@{
        Name = "CPUUsage"
        Value = 80
    },
    [PSCustomObject]@{
        Name = "MemoryUsage"
        Value = 60
    }
)
```

New-LMPushMetricDataPoint -DataPoints $datapoints -DataPointType "gauge" -DataPointAggregationType "avg"

This example creates two data points for CPU usage and memory usage, and sets the data point type to "gauge" and the aggregation type to "avg".

## PARAMETERS

### -DataPointsArray
An optional parameter that allows you to pass an existing array of data points.
If not provided, a new array will be created.

```yaml
Type: System.Collections.Generic.List`1[System.Object]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataPoints
A mandatory parameter that accepts an array of data points.
Each data point should be an object with a Name and a Value property.

```yaml
Type: System.Collections.Generic.List`1[System.Object]
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataPointType
Specifies the type of the data point.
Valid values are "counter", "derive", and "gauge".
The default value is "gauge".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: Gauge
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataPointAggregationType
Specifies the aggregation type of the data point.
Valid values are "min", "max", "avg", "sum", "none", and "percentile".
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

### -PercentileValue
Specifies the percentile value for the data point.
This parameter is only applicable when the DataPointAggregationType is set to "percentile".
The value should be between 0 and 100.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 0
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
LogicMonitor API credentials must be set before using this function.
Use the Connect-LMAccount function to log in and set the credentials.

## RELATED LINKS
