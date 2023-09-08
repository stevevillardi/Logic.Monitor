---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceGroupSDT

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### OneTime-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceGroupName <String>
 [-DataSourceId <String>] [-DataSourceName <String>] [<CommonParameters>]
```

### OneTime-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartDate <DateTime> -EndDate <DateTime> -DeviceGroupId <String>
 [-DataSourceId <String>] [-DataSourceName <String>] [<CommonParameters>]
```

### Weekly-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceGroupId <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [<CommonParameters>]
```

### MonthlyByWeek-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceGroupId <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [<CommonParameters>]
```

### Monthly-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceGroupId <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [<CommonParameters>]
```

### Daily-DeviceGroupId
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceGroupId <String> [-DataSourceId <String>] [-DataSourceName <String>]
 [<CommonParameters>]
```

### Weekly-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -DeviceGroupName <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [<CommonParameters>]
```

### MonthlyByWeek-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -WeekDay <String> -WeekOfMonth <String> -DeviceGroupName <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [<CommonParameters>]
```

### Monthly-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DayOfMonth <Int32> -DeviceGroupName <String> [-DataSourceId <String>]
 [-DataSourceName <String>] [<CommonParameters>]
```

### Daily-DeviceGroupName
```
New-LMDeviceGroupSDT -Comment <String> -StartHour <Int32> -StartMinute <Int32> -EndHour <Int32>
 -EndMinute <Int32> -DeviceGroupName <String> [-DataSourceId <String>] [-DataSourceName <String>]
 [<CommonParameters>]
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

### -DataSourceId
{{ Fill DataSourceId Description }}

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

### -DataSourceName
{{ Fill DataSourceName Description }}

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

### -DayOfMonth
{{ Fill DayOfMonth Description }}

```yaml
Type: Int32
Parameter Sets: Monthly-DeviceGroupId, Monthly-DeviceGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupId
{{ Fill DeviceGroupId Description }}

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
{{ Fill DeviceGroupName Description }}

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

### -EndDate
{{ Fill EndDate Description }}

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

### -EndHour
{{ Fill EndHour Description }}

```yaml
Type: Int32
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
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
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
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
Parameter Sets: OneTime-DeviceGroupName, OneTime-DeviceGroupId
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
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
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
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Monthly-DeviceGroupId, Daily-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName, Monthly-DeviceGroupName, Daily-DeviceGroupName
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
Parameter Sets: Weekly-DeviceGroupId, MonthlyByWeek-DeviceGroupId, Weekly-DeviceGroupName, MonthlyByWeek-DeviceGroupName
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
Parameter Sets: MonthlyByWeek-DeviceGroupId, MonthlyByWeek-DeviceGroupName
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
