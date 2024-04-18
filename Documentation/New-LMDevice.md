---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDevice

## SYNOPSIS
Creates a new LogicMonitor device.

## SYNTAX

```
New-LMDevice [-Name] <String> [-DisplayName] <String> [[-Description] <String>] [-PreferredCollectorId] <Int32>
 [[-PreferredCollectorGroupId] <Int32>] [[-AutoBalancedCollectorGroupId] <Int32>] [[-DeviceType] <Int32>]
 [[-Properties] <Hashtable>] [[-HostGroupIds] <String[]>] [[-Link] <String>] [[-DisableAlerting] <Boolean>]
 [[-EnableNetFlow] <Boolean>] [[-NetflowCollectorGroupId] <Int32>] [[-NetflowCollectorId] <Int32>]
 [[-LogCollectorGroupId] <Int32>] [[-LogCollectorId] <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDevice function creates a new LogicMonitor device with the specified parameters.
It sends a POST request to the LogicMonitor API to create the device.

## EXAMPLES

### EXAMPLE 1
```
New-LMDevice -Name "Server001" -DisplayName "Server 001" -Description "Web server" -PreferredCollectorId 1234 -HostGroupIds @("Group1", "Group2")
```

This example creates a new LogicMonitor device with the name "Server001", display name "Server 001", description "Web server", and preferred collector ID 1234.
It assigns the device to host groups "Group1" and "Group2".

## PARAMETERS

### -Name
The name of the device.
This parameter is mandatory.

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

### -DisplayName
The display name of the device.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the device.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreferredCollectorId
The ID of the preferred collector for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PreferredCollectorGroupId
The ID of the preferred collector group for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoBalancedCollectorGroupId
The ID of the auto-balanced collector group for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceType
The type of the device.
Default value is 0.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
A hashtable of custom properties for the device.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HostGroupIds
An array of host group IDs for the device.
Dynamic group IDs will be ignored, and the operation will replace all existing groups.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Link
The link associated with the device.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAlerting
Specifies whether alerting is disabled for the device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableNetFlow
Specifies whether NetFlow is enabled for the device.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowCollectorGroupId
The ID of the NetFlow collector group for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowCollectorId
The ID of the NetFlow collector for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogCollectorGroupId
The ID of the log collector group for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogCollectorId
The ID of the log collector for the device.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
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
This function requires a valid API authentication.
Make sure you are logged in before running any commands using Connect-LMAccount.

## RELATED LINKS
