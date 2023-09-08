---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMSDT

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### OneTime (Default)
```
Set-LMSDT -Id <String> [-Comment <String>] [-StartDate <DateTime>] [-EndDate <DateTime>] [<CommonParameters>]
```

### Recurring
```
Set-LMSDT -Id <String> [-Comment <String>] [-StartHour <Int32>] [-StartMinute <Int32>] [-EndHour <Int32>]
 [-EndMinute <Int32>] [-WeekDay <String>] [-WeekOfMonth <String>] [-DayOfMonth <Int32>] [<CommonParameters>]
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
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
{{ Fill EndDate Description }}

```yaml
Type: DateTime
Parameter Sets: OneTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndHour
{{ Fill EndHour Description }}

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndMinute
{{ Fill EndMinute Description }}

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

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
{{ Fill StartDate Description }}

```yaml
Type: DateTime
Parameter Sets: OneTime
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartHour
{{ Fill StartHour Description }}

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartMinute
{{ Fill StartMinute Description }}

```yaml
Type: Int32
Parameter Sets: Recurring
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekDay
{{ Fill WeekDay Description }}

```yaml
Type: String
Parameter Sets: Recurring
Aliases:
Accepted values: Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WeekOfMonth
{{ Fill WeekOfMonth Description }}

```yaml
Type: String
Parameter Sets: Recurring
Aliases:
Accepted values: First, Second, Third, Fourth, Last

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
