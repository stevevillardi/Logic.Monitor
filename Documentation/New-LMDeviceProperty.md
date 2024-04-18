---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceProperty

## SYNOPSIS
Creates a new device property in LogicMonitor.

## SYNTAX

### Id (Default)
```
New-LMDeviceProperty -Id <Int32> -PropertyName <String> -PropertyValue <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
New-LMDeviceProperty -Name <String> -PropertyName <String> -PropertyValue <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceProperty function creates a new device property in LogicMonitor.
It allows you to specify the property name and value, and either the device ID or device name.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceProperty -Id 1234 -PropertyName "Location" -PropertyValue "New York"
```

Creates a new device property with the name "Location" and value "New York" for the device with ID 1234.

### EXAMPLE 2
```
New-LMDeviceProperty -Name "Server01" -PropertyName "Environment" -PropertyValue "Production"
```

Creates a new device property with the name "Environment" and value "Production" for the device with the name "Server01".

## PARAMETERS

### -Id
Specifies the ID of the device.
This parameter is mandatory when using the 'Id' parameter set.

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
Specifies the name of the device.
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
Specifies the name of the property to create.

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

### -PropertyValue
Specifies the value of the property to create.

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
- You must be logged in and have valid API credentials to use this function. Use Connect-LMAccount to log in.
- Wildcard values are not supported for the device name.
- If the device name is not found, an error will be displayed.

## RELATED LINKS
