---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMConfigsource

## SYNOPSIS
Removes a LogicMonitor configsource.

## SYNTAX

### Id (Default)
```
Remove-LMConfigsource -Id <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Remove-LMConfigsource -Name <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMConfigsource function removes a LogicMonitor configsource based on the specified Id or Name.
It requires valid API credentials and the user must be logged in before running any commands.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMConfigsource -Id 123
Removes the configsource with Id 123.
```

### EXAMPLE 2
```
Remove-LMConfigsource -Name "ConfigSource1"
Removes the configsource with the name "ConfigSource1".
```

## PARAMETERS

### -Id
Specifies the Id of the configsource to remove.
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
Specifies the Name of the configsource to remove.
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

### You can pipe input to this function.
## OUTPUTS

### System.Management.Automation.PSCustomObject
### Returns an object with the following properties:
### - Id: The Id of the removed configsource.
### - Message: A message indicating the success of the removal operation.
## NOTES
Please ensure you are logged in before running any commands.
Use Connect-LMAccount to login and try again.

## RELATED LINKS
