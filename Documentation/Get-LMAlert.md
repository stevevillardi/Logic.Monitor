---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAlert

## SYNOPSIS
Retrieves LogicMonitor alerts based on specified parameters.

## SYNTAX

### All (Default)
```
Get-LMAlert [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>] [-BatchSize <Int32>]
 [-Sort <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Range
```
Get-LMAlert [-StartDate <DateTime>] [-EndDate <DateTime>] [-Severity <String>] [-Type <String>]
 [-ClearedAlerts <Boolean>] [-BatchSize <Int32>] [-Sort <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id
```
Get-LMAlert -Id <String> [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>]
 [-CustomColumns <String[]>] [-BatchSize <Int32>] [-Sort <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMAlert [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>] [-Filter <Object>]
 [-BatchSize <Int32>] [-Sort <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAlert function retrieves LogicMonitor alerts based on the specified parameters.
It supports filtering alerts by start and end dates, severity, type, cleared status, and custom columns.
The function makes API requests to the LogicMonitor platform and returns the retrieved alerts.

## EXAMPLES

### EXAMPLE 1
```
Get-LMAlert -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -Severity "Error" -Type "websiteAlert" -ClearedAlerts $false
Retrieves all alerts that occurred within the last 7 days, have a severity level of "Error", are of type "websiteAlert", and are not cleared.
```

### EXAMPLE 2
```
Get-LMAlert -Id "12345" -CustomColumns "Column1", "Column2"
Retrieves a specific alert with the ID "12345" and includes the custom columns "Column1" and "Column2" in the result.
```

## PARAMETERS

### -StartDate
Specifies the start date for filtering alerts.
Only alerts that occurred after this date will be retrieved.

```yaml
Type: DateTime
Parameter Sets: Range
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Specifies the end date for filtering alerts.
Only alerts that occurred before this date will be retrieved.

```yaml
Type: DateTime
Parameter Sets: Range
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the ID of a specific alert to retrieve.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Severity
Specifies the severity level of alerts to retrieve.
Valid values are "*", "Warning", "Error", and "Critical".
The default value is "*".

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

### -Type
Specifies the type of alerts to retrieve.
Valid values are "*", "websiteAlert", "dataSourceAlert", "eventSourceAlert", and "logAlert".
The default value is "*".

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

### -ClearedAlerts
Specifies whether to retrieve cleared alerts.
If set to $true, cleared alerts will be included in the results.
If set to $false, only active alerts will be included.
The default value is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Specifies a custom filter object to further refine the alerts to retrieve.

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

### -CustomColumns
Specifies an array of custom columns to include in the retrieved alerts.

```yaml
Type: String[]
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
Specifies the number of alerts to retrieve per API request.
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

### -Sort
Specifies the sorting order of the retrieved alerts.
The default value is "resourceId".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: ResourceId
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
This function requires a valid API authentication session.
Use the Connect-LMAccount function to log in before running this command.

## RELATED LINKS
