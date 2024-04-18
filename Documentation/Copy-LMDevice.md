---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Copy-LMDevice

## SYNOPSIS
Copies a LogicMonitor device.

## SYNTAX

```
Copy-LMDevice [-Name] <String> [[-DisplayName] <String>] [[-Description] <String>] [-DeviceObject] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Copy-LMDevice function is used to create a copy of a LogicMonitor device.
It takes the name, display name, description, and device object as parameters and creates a new device with the specified properties.

## EXAMPLES

### EXAMPLE 1
```
Copy-LMDevice -Name "NewDevice" -DeviceObject $deviceObject
Creates a copy of the device specified by the $deviceObject variable with the name "NewDevice".
```

## PARAMETERS

### -Name
The name of the new device.

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
The display name of the new device.
If not provided, the name parameter will be used as the display name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: $Name
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the new device.

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

### -DeviceObject
The device object of the reference device that will be copied.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
Any custom properties from the reference device that are masked will need to be updated on the cloned resource, as those values are not available to the LogicMonitor API.

## RELATED LINKS
