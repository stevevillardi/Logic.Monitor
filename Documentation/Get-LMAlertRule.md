---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAlertRule

## SYNOPSIS
Get list of alert rules in bulk or by id.

## SYNTAX

### All (Default)
```
Get-LMAlertRule [-BatchSize <Int32>] [<CommonParameters>]
```

### Id
```
Get-LMAlertRule [-Id <Int32>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Name
```
Get-LMAlertRule [-Name <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Filter
```
Get-LMAlertRule [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get list of alert rules in bulk or by id.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-LMAlertRule -Id 1
```

Get alert rule detail for all alerts that start with "Test*".

### Example 2
```powershell
PS C:\> Get-LMAlertRule -Name "Test*"
```

Get alert rule detail for alert rule id 1.

## PARAMETERS

### -BatchSize
Set batch size for the number of results return per api request. Default value is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Apply a custom filter to query for alerts rules. Filters are currently treated as exact matches.

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

### -Id
Id of the alert rule to return.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Name of the alert rule to return. Name field accepts wildcards to return multiple rules matching a specified string.

```yaml
Type: String
Parameter Sets: Name
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
