---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMCollector

## SYNOPSIS
Creates a new LogicMonitor collector.

## SYNTAX

```
New-LMCollector [-Description] <String> [[-BackupAgentId] <Int32>] [[-CollectorGroupId] <Int32>]
 [[-Properties] <Hashtable>] [[-EnableFailBack] <Boolean>] [[-EnableFailOverOnCollectorDevice] <Boolean>]
 [[-EscalatingChainId] <Int32>] [[-AutoCreateCollectorDevice] <Boolean>] [[-SuppressAlertClear] <Boolean>]
 [[-ResendAlertInterval] <Int32>] [[-SpecifiedCollectorDeviceGroupId] <Int32>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMCollector function is used to create a new collector in LogicMonitor.
It requires a description for the collector and supports various optional parameters such as BackupAgentId, CollectorGroupId, Properties, EnableFailBack, EnableFailOverOnCollectorDevice, EscalatingChainId, AutoCreateCollectorDevice, SuppressAlertClear, ResendAlertInterval, and SpecifiedCollectorDeviceGroupId.

## EXAMPLES

### EXAMPLE 1
```
New-LMCollector -Description "My Collector" -BackupAgentId 123 -CollectorGroupId 456 -Properties @{ "Key1" = "Value1"; "Key2" = "Value2" }
```

This example creates a new collector with the specified description, backup agent ID, collector group ID, and custom properties.

## PARAMETERS

### -Description
The description of the collector.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BackupAgentId
The ID of the backup agent.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorGroupId
The ID of the collector group.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
A hashtable of custom properties for the collector.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableFailBack
Specifies whether failback is enabled for the collector.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableFailOverOnCollectorDevice
Specifies whether failover is enabled on the collector device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EscalatingChainId
The ID of the escalation chain.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoCreateCollectorDevice
Specifies whether to automatically create a collector device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuppressAlertClear
Specifies whether to suppress alert clear.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResendAlertInterval
The interval for resending alerts.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpecifiedCollectorDeviceGroupId
The ID of the specified collector device group.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
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

## RELATED LINKS
