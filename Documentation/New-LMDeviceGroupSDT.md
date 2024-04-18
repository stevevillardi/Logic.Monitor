---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceGroupSDT

## SYNOPSIS
Creates a new LogicMonitor Device Group Scheduled Downtime.

## SYNTAX

### OneTime-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceGroupName <String>
 [-DataSourceId <String>] [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### OneTime-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceGroupId <String>
 [-DataSourceId <String>] [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Weekly-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceGroupId <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### MonthlyByWeek-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceGroupId <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Monthly-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceGroupId <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Daily-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceGroupId <String> [-DataSourceId <String>] [-DataSourceName <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Weekly-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceGroupName <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### MonthlyByWeek-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceGroupName <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Monthly-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceGroupName <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Daily-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceGroupName <String> [-DataSourceId <String>] [-DataSourceName <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceGroupSDT function creates a new scheduled downtime for a LogicMonitor device group.
This allows you to temporarily disable monitoring for a specific group of devices within your LogicMonitor account.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceGroupSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00:00" -EndDate "2022-01-01 06:00:00" -StartHour 2 -DeviceGroupName "Production Servers"
Creates a new scheduled downtime for the "Production Servers" device group, starting from January 1, 2022, 00:00:00 and ending on January 1, 2022, 06:00:00. The scheduled downtime will occur every day at 2 AM.
```

### EXAMPLE 2
```
New-LMDeviceGroupSDT -Comment "Monthly maintenance" -StartHour 8 -DeviceGroupId 12345 -Monthly
Creates a new scheduled downtime for the device group with ID 12345, starting at 8 AM. The scheduled downtime will occur every month.
```

## PARAMETERS

### -Comment
Specifies the comment for the scheduled downtime.
This comment will be displayed in the LogicMonitor UI.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
Specifies the start date and time for the scheduled downtime.
This parameter is mandatory when using the 'OneTime-DeviceGroupId' or 'OneTime-DeviceGroupName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceGroupName, OneTime-DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Specifies the end date and time for the scheduled downtime.
This parameter is mandatory when using the 'OneTime-DeviceGroupId' or 'OneTime-DeviceGroupName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceGroupName, OneTime-DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
Specifies the start hour for the scheduled downtime.
This parameter is mandatory when using the 'Daily-DeviceGroupName', 'Monthly-DeviceGroupName', 'MonthlyByWeek-DeviceGroupName', 'Weekly-DeviceGroupName', 'Daily-DeviceGroupId', 'Monthly-DeviceGroupId', 'MonthlyByWeek-DeviceGroupId', or 'Weekly-DeviceGroupId' parameter sets.
The value must be between 0 and 23.

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartMinute
{{ Fill StartMinute Description }}

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndHour
{{ Fill EndHour Description }}

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndMinute
{{ Fill EndMinute Description }}

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekDay
{{ Fill WeekDay Description }}

```yaml
Type: String
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekOfMonth
{{ Fill WeekOfMonth Description }}

```yaml
Type: String
Parameter Sets: MonthlyByWeek-DeviceGroupId, MonthlyByWeek-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DayOfMonth
{{ Fill DayOfMonth Description }}

```yaml
Type: Int32
Parameter Sets: Monthly-DeviceGroupId, Monthly-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupId
Specifies the ID of the device group for which the scheduled downtime should be created.
This parameter is mandatory when using the 'OneTime-DeviceGroupId', 'Daily-DeviceGroupId', 'Monthly-DeviceGroupId', 'MonthlyByWeek-DeviceGroupId', or 'Weekly-DeviceGroupId' parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceGroupId, Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupName
Specifies the name of the device group for which the scheduled downtime should be created.
This parameter is mandatory when using the 'OneTime-DeviceGroupName', 'Daily-DeviceGroupName', 'Monthly-DeviceGroupName', 'MonthlyByWeek-DeviceGroupName', or 'Weekly-DeviceGroupName' parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceGroupName, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSourceId
{{ Fill DataSourceId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSourceName
{{ Fill DataSourceName Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: All
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

## RELATED LINKS
