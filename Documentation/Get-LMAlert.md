---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAlert

## SYNOPSIS
Get LM Alert in bulk or by id.

## SYNTAX

### All (Default)
```
Get-LMAlert [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>] [-BatchSize <Int32>]
 [-Sort <String>] [<CommonParameters>]
```

### Range
```
Get-LMAlert [-StartDate <DateTime>] [-EndDate <DateTime>] [-Severity <String>] [-Type <String>]
 [-ClearedAlerts <Boolean>] [-BatchSize <Int32>] [-Sort <String>] [<CommonParameters>]
```

### Id
```
Get-LMAlert -Id <String> [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>]
 [-CustomColumns <String[]>] [-BatchSize <Int32>] [-Sort <String>] [<CommonParameters>]
```

### Filter
```
Get-LMAlert [-Severity <String>] [-Type <String>] [-ClearedAlerts <Boolean>] [-Filter <Object>]
 [-BatchSize <Int32>] [-Sort <String>] [<CommonParameters>]
```

## DESCRIPTION
Get LM Alert in bulk or by id.

## EXAMPLES

### Example 1
```powershell
PS C:\> Get-LMAlert -StartDate $(Get-Date).AddDays(-1) -EndDate $(Get-Date) -ClearedAlerts $true | Group-Object -Property resourceTemplateName,datapointName | select count, @{N='Name';E={$_.Name.Split(",")[0]}}, @{N='Datapoint';E={$_.Name.Split(",")[1]}} | Sort-Object -Property count -Descending
```

Get all alerts from the last 24 hours.

### Example 2
```powershell
PS C:\> Get-LMAlert -Id DS67152170
```

Get all details for alert id DS67152170.

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

### -ClearedAlerts
Include cleared alerts in the response.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomColumns
When get an alert by id, you can optionally include custom properties as part of the response

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

### -EndDate
End date for filtered alert range

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

### -Filter
Apply a custom filter to query the alerts list. Filters are currently treated as exact matches.

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
Alert Id for the alert you wish the lookup.

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
Severity of the alerts to return. By default will search all alerts.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: *, Warning, Error, Critical

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Sort
{{ Fill Sort Description }}

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
Start date for filtered alert range

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

### -Type
Type of alerts to return. By default will return alerts for all types.

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: *, websiteAlert, dataSourceAlert, eventSourceAlert, logAlert

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
