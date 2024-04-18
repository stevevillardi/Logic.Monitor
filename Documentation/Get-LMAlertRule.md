---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAlertRule

## SYNOPSIS
Retrieves LogicMonitor alert rules based on specified parameters.

## SYNTAX

### All (Default)
```
Get-LMAlertRule [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMAlertRule [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMAlertRule [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMAlertRule [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAlertRule function retrieves LogicMonitor alert rules based on the specified parameters.
It supports retrieving alert rules by ID, name, or using a filter.
The function uses the LogicMonitor REST API to make the requests.

## EXAMPLES

### EXAMPLE 1
```
Get-LMAlertRule -Id 123
Retrieves the alert rule with the specified ID.
```

### EXAMPLE 2
```
Get-LMAlertRule -Name "High CPU Usage"
Retrieves the alert rule with the specified name.
```

## PARAMETERS

### -Id
Specifies the ID of the alert rule to retrieve.
This parameter is mutually exclusive with the Name and Filter parameters.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the alert rule to retrieve.
This parameter is mutually exclusive with the Id and Filter parameters.

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

### -Filter
Specifies a filter object to retrieve alert rules based on specific criteria.
This parameter is mutually exclusive with the Id and Name parameters.

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

### -BatchSize
Specifies the number of alert rules to retrieve in each request.
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

## OUTPUTS

## NOTES
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this function.

## RELATED LINKS
