---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceSDT

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### OneTime-DeviceName
```
New-LMDeviceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceName <String>
 [<CommonParameters>]
```

### OneTime-DeviceId
```
New-LMDeviceSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceId <String>
 [<CommonParameters>]
```

### Weekly-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> [<CommonParameters>]
```

### MonthlyByWeek-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> [<CommonParameters>]
```

### Monthly-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> [<CommonParameters>]
```

### Daily-DeviceId
```
New-LMDeviceSDT -Comment <String> -DeviceId <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> [<CommonParameters>]
```

### Weekly-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> [<CommonParameters>]
```

### MonthlyByWeek-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> [<CommonParameters>]
```

### Monthly-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> [<CommonParameters>]
```

### Daily-DeviceName
```
New-LMDeviceSDT -Comment <String> -DeviceName <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> [<CommonParameters>]
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

### -Comment
{{ Fill Comment Description }}

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

### -DayOfMonth
{{ Fill DayOfMonth Description }}

```yaml
Type: Int32
Parameter Sets: Monthly-DeviceId, Monthly-DeviceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
{{ Fill DeviceId Description }}

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
{{ Fill DeviceName Description }}

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

### -EndDate
{{ Fill EndDate Description }}

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

### -EndHour
{{ Fill EndHour Description }}

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
{{ Fill StartDate Description }}

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

### -StartHour
{{ Fill StartHour Description }}

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Monthly-DeviceId, Daily-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName, Monthly-DeviceName, Daily-DeviceName
Aliases:

Required: True
Position: Named
Default value: None
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
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekDay
{{ Fill WeekDay Description }}

```yaml
Type: String
Parameter Sets: Weekly-DeviceId, MonthlyByWeek-DeviceId, Weekly-DeviceName, MonthlyByWeek-DeviceName
Aliases:
Accepted values: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

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
Accepted values: First, Second, Third, Fourth, Last

Required: True
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
