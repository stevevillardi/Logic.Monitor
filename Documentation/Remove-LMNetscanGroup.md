---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMNetscanGroup

## SYNOPSIS
Removes a LogicMonitor NetScan group.

## SYNTAX

### Id (Default)
```
Remove-LMNetscanGroup -Id <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Remove-LMNetscanGroup -Name <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMNetscanGroup function removes a LogicMonitor NetScan group based on the specified ID or name.
It requires valid API credentials to be logged in.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMNetscanGroup -Id 123
Removes the NetScan group with ID 123.
```

### EXAMPLE 2
```
Remove-LMNetscanGroup -Name "MyGroup"
Removes the NetScan group with the name "MyGroup".
```

## PARAMETERS

### -Id
Specifies the ID of the NetScan group to remove.
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
Specifies the name of the NetScan group to remove.
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

### You can pipe objects to this function.
## OUTPUTS

### System.Management.Automation.PSCustomObject
### Returns an object with the following properties:
### - Id: The ID of the removed NetScan group.
### - Message: A message indicating the success of the removal operation.
## NOTES
This function requires valid API credentials to be logged in.
Use the Connect-LMAccount function to log in before running any commands.

## RELATED LINKS
