---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMPushMetricDataPoint

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-LMPushMetricDataPoint [[-DataPointsArray] <Array>] [-DataPoints] <Hashtable> [[-DataPointType] <String>]
 [[-DataPointAggregationType] <String>] [[-PercentileValue] <Int32>] [<CommonParameters>]
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

### -DataPointAggregationType
{{ Fill DataPointAggregationType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: min, max, avg, sum, none, percentile

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataPointType
{{ Fill DataPointType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: counter, derive, gauge

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataPoints
{{ Fill DataPoints Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataPointsArray
{{ Fill DataPointsArray Description }}

```yaml
Type: Array
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PercentileValue
{{ Fill PercentileValue Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
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
