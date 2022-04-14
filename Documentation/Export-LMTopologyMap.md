---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMTopologyMap

## SYNOPSIS
Exports a topology map to a standalone HTML file.

## SYNTAX

### Id
```
Export-LMTopologyMap -Id <Int32> [-IncludeUndiscoveredDevices <Boolean>] [-IncludeDataTable <Boolean>]
 [-EnablePhysics <Boolean>] [-BackgroundImage <String>] [<CommonParameters>]
```

### Name
```
Export-LMTopologyMap -Name <String> [-IncludeUndiscoveredDevices <Boolean>] [-IncludeDataTable <Boolean>]
 [-EnablePhysics <Boolean>] [-BackgroundImage <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports a topology map to a standalone HTML file.

## EXAMPLES

### EXAMPLE 1
```
Export-LMTopologyMap -Id 12 -IncludeUndiscoveredDevices $false
```

### EXAMPLE 2
```
Export-LMTopologyMap Name "VMware Environment" -IncludeDataTable $true
```

## PARAMETERS

### -Id
Id of the topology map you want to export

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
Name of the topology map you are looking to export, used as an alternative to Id

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

### -IncludeUndiscoveredDevices
Include undiscovered devices in topology export

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

### -IncludeDataTable
Include a data table alongside the exported map

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

### -EnablePhysics
Enable physics interaction on the generated topology map

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

### -BackgroundImage
Add a background image to the exported topology map

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES
Currently a beta command, topology map export is still under developement, please report any bugs you encounter while using this command.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

