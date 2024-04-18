---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceGroup

## SYNOPSIS
Creates a new LogicMonitor device group.

## SYNTAX

### GroupId
```
New-LMDeviceGroup -Name <String> [-Description <String>] [-Properties <Hashtable>] [-DisableAlerting <Boolean>]
 [-EnableNetFlow <Boolean>] -ParentGroupId <Int32> [-AppliesTo <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### GroupName
```
New-LMDeviceGroup -Name <String> [-Description <String>] [-Properties <Hashtable>] [-DisableAlerting <Boolean>]
 [-EnableNetFlow <Boolean>] -ParentGroupName <String> [-AppliesTo <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceGroup function creates a new LogicMonitor device group with the specified parameters.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceGroup -Name "MyDeviceGroup" -Description "This is a test device group" -Properties @{ "Location" = "US"; "Environment" = "Production" } -DisableAlerting $true
```

This example creates a new LogicMonitor device group named "MyDeviceGroup" with a description and custom properties.
Alerting is disabled for this device group.

### EXAMPLE 2
```
New-LMDeviceGroup -Name "ChildDeviceGroup" -ParentGroupName "ParentDeviceGroup"
```

This example creates a new LogicMonitor device group named "ChildDeviceGroup" with a specified parent device group.

## PARAMETERS

### -Name
The name of the device group.
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

### -Description
The description of the device group.

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

### -Properties
A hashtable of custom properties for the device group.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAlerting
Specifies whether alerting is disabled for the device group.
The default value is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableNetFlow
Specifies whether NetFlow is enabled for the device group.
The default value is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
The ID of the parent device group.
This parameter is mandatory when using the 'GroupId' parameter set.

```yaml
Type: Int32
Parameter Sets: GroupId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
The name of the parent device group.
This parameter is mandatory when using the 'GroupName' parameter set.

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

### -AppliesTo
The applies to value for the device group.

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
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this command.

## RELATED LINKS
