---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMDeviceProperty

## SYNOPSIS
Removes a property from a LogicMonitor device.

## SYNTAX

### Id (Default)
```
Remove-LMDeviceProperty -Id <Int32> -PropertyName <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### Name
```
Remove-LMDeviceProperty -Name <String> -PropertyName <String> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMDeviceProperty function removes a specified property from a LogicMonitor device.
It can remove the property either by providing the device ID or the device name.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMDeviceProperty -Id 1234 -PropertyName "Property1"
Removes the property named "Property1" from the device with ID 1234.
```

### EXAMPLE 2
```
Remove-LMDeviceProperty -Name "Device1" -PropertyName "Property2"
Removes the property named "Property2" from the device with the name "Device1".
```

## PARAMETERS

### -Id
The ID of the device from which the property should be removed.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the device from which the property should be removed.
This parameter is mandatory when using the 'Name' parameter set.

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

### -PropertyName
The name of the property to be removed.
This parameter is mandatory.

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

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
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

### None.
## OUTPUTS

### System.Management.Automation.PSCustomObject. The output object contains the following properties:
### - Id: The ID of the device from which the property was removed.
### - Message: A message indicating the success of the operation.
## NOTES
- This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running any commands.
- Use the Connect-LMAccount function to log in before using this function.

## RELATED LINKS
