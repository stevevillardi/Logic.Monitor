---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMActiveDiscovery

## SYNOPSIS
Invokes an active discovery task for LogicMonitor devices.

## SYNTAX

### Id
```
Invoke-LMActiveDiscovery -Id <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Invoke-LMActiveDiscovery -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupId
```
Invoke-LMActiveDiscovery -GroupId <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName
```
Invoke-LMActiveDiscovery -GroupName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMActiveDiscovery function is used to schedule an active discovery task for LogicMonitor devices. 
It accepts parameters to specify the devices for which the active discovery task should be scheduled.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMActiveDiscovery -Id 12345
Invokes an active discovery task for the device with ID 12345.
```

### EXAMPLE 2
```
Invoke-LMActiveDiscovery -Name "MyDevice"
Invokes an active discovery task for the device with the name "MyDevice".
```

### EXAMPLE 3
```
Invoke-LMActiveDiscovery -GroupId "123"
Invokes an active discovery task for all devices in the device group with ID "123".
```

### EXAMPLE 4
```
Invoke-LMActiveDiscovery -GroupName "Group2"
Invokes an active discovery task for all devices in the device group with the name "Group2".
```

## PARAMETERS

### -Id
Specifies the ID of the device for which the active discovery task should be scheduled.
This parameter is mutually exclusive with the Name parameter.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
Specifies the name of the device for which the active discovery task should be scheduled.
This parameter is mutually exclusive with the Id parameter.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId
Specifies the ID of the device group for which the active discovery task should be scheduled.
This parameter is mutually exclusive with the GroupName parameter.

```yaml
Type: String
Parameter Sets: GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupName
Specifies the name of the device group for which the active discovery task should be scheduled.
This parameter is mutually exclusive with the GroupId parameter.

```yaml
Type: String
Parameter Sets: GroupName
Aliases:

Required: True
Position: Named
Default value: None
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
- This function requires a valid API authentication. Make sure you are logged in before running any commands.
- Use the Connect-LMAccount function to log in and obtain valid API credentials.

## RELATED LINKS
