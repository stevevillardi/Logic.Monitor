---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceSDT

## SYNOPSIS
Creates a new Logic Monitor Device Scheduled Down Time (SDT).

## SYNTAX

### OneTime-DeviceName
```
New-LMDeviceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceName <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### OneTime-DeviceId
```
New-LMDeviceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Weekly-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### MonthlyByWeek-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Monthly-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Daily-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Weekly-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### MonthlyByWeek-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Monthly-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Daily-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceSDT function creates a new SDT for a Logic Monitor device.
It allows you to specify the comment, start date, end date, timezone, and device ID or device name.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceSDT -Comment "Maintenance window" -StartDate "2022-01-01 00:00:00" -EndDate "2022-01-01 06:00:00" -DeviceId "12345"
Creates a one-time SDT for the device with ID "12345" starting from January 1, 2022, 00:00:00 and ending on January 1, 2022, 06:00:00 with the comment "Maintenance window".
```

### EXAMPLE 2
```
New-LMDeviceSDT -Comment "Daily maintenance window" -StartDate "2022-01-01 00:00:00" -EndDate "2022-01-01 06:00:00" -DeviceName "Server01"
Creates a daily recurring SDT for the device with name "Server01" starting from January 1, 2022, 00:00:00 and ending on January 1, 2022, 06:00:00 with the comment "Daily maintenance window".
```

## PARAMETERS

### -Comment
Specifies the comment for the SDT.

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
Specifies the start date and time for the SDT.
This parameter is mandatory when using the 'OneTime-DeviceId' or 'OneTime-DeviceName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceName, OneTime-DeviceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
Specifies the end date and time for the SDT.
This parameter is mandatory when using the 'OneTime-DeviceId' or 'OneTime-DeviceName' parameter sets.

```yaml
Type: DateTime
Parameter Sets: OneTime-DeviceName, OneTime-DeviceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
Specifies the ID of the device for which the SDT is being created.
This parameter is mandatory when using the 'OneTime-DeviceId', 'Daily-DeviceId', 'Monthly-DeviceId', 'MonthlyByWeek-DeviceId', or 'Weekly-DeviceId' parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceId, Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceName
Specifies the name of the device for which the SDT is being created.
This parameter is mandatory when using the 'OneTime-DeviceName', 'Daily-DeviceName', 'Monthly-DeviceName', 'MonthlyByWeek-DeviceName', or 'Weekly-DeviceName' parameter sets.

```yaml
Type: String
Parameter Sets: OneTime-DeviceName, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
{{ Fill StartHour Description }}

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
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
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
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
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
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
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
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
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName
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
Parameter Sets: MonthlyByWeek-DeviceId, MonthlyByWeek-DeviceName
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
Parameter Sets: Monthly-DeviceId, Monthly-DeviceName
Aliases:

Required: True
Position: Named
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

## RELATED LINKS
