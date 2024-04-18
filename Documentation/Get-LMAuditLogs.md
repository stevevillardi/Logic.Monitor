---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version: https://www.logicmonitor.com/support/rest-api-developers-guide/
schema: 2.0.0
---

# Get-LMAuditLogs

## SYNOPSIS
Retrieves audit logs from LogicMonitor.

## SYNTAX

### Range (Default)
```
Get-LMAuditLogs [-SearchString <String>] [-StartDate <DateTime>] [-EndDate <DateTime>] [-BatchSize <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMAuditLogs [-Id <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Filter
```
Get-LMAuditLogs [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAuditLogs function retrieves audit logs from LogicMonitor based on the specified parameters.
It supports retrieving logs by ID, by date range, or by applying filters.

## EXAMPLES

### EXAMPLE 1
```
Get-LMAuditLogs -Id "12345"
Retrieves the audit log with the specified ID.
```

### EXAMPLE 2
```
Get-LMAuditLogs -SearchString "login" -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date)
Retrieves audit logs that contain the search string "login" and occurred within the last 7 days.
```

## PARAMETERS

### -Id
Specifies the ID of the audit log to retrieve.
This parameter is mutually exclusive with the SearchString, StartDate, EndDate, and Filter parameters.

```yaml
Type: String
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SearchString
Specifies a search string to filter the audit logs.
Only logs that contain the specified search string will be returned.
This parameter is used in conjunction with the StartDate and EndDate parameters.

```yaml
Type: String
Parameter Sets: Range
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
Specifies the start date of the audit logs to retrieve.
Only logs that occurred on or after the specified start date will be returned.
This parameter is used in conjunction with the SearchString and EndDate parameters.

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
Specifies the end date of the audit logs to retrieve.
Only logs that occurred on or before the specified end date will be returned.
This parameter is used in conjunction with the SearchString and StartDate parameters.

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
Specifies a filter object to further refine the audit logs to retrieve.
This parameter is used in conjunction with the StartDate and EndDate parameters.

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
Specifies the number of audit logs to retrieve per request.
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
This function requires a valid connection to LogicMonitor.
Use Connect-LMAccount to establish a connection before running this command.

## RELATED LINKS
