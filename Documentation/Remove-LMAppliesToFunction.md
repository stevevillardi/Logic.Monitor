---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMAppliesToFunction

## SYNOPSIS
Removes an AppliesTo function from LogicMonitor.

## SYNTAX

### Name
```
Remove-LMAppliesToFunction -Name <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Id
```
Remove-LMAppliesToFunction -Id <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMAppliesToFunction function removes an AppliesTo function from LogicMonitor.
It can be used to remove a function either by its name or its ID.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMAppliesToFunction -Name "MyAppliesToFunction"
Removes the AppliesTo function with the name "MyAppliesToFunction".
```

### EXAMPLE 2
```
Remove-LMAppliesToFunction -Id 12345
Removes the AppliesTo function with the ID 12345.
```

## PARAMETERS

### -Name
Specifies the name of the AppliesTo function to be removed.
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

### -Id
Specifies the ID of the AppliesTo function to be removed.
This parameter is mandatory when using the 'Id' parameter set.
The ID can be obtained using the Get-LMAppliesToFunction cmdlet.

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

### None. You cannot pipe input to this function.
## OUTPUTS

### System.Management.Automation.PSCustomObject. The function returns an object with the following properties:
### - Id: The ID of the removed AppliesTo function.
### - Message: A message indicating the success of the removal operation.
## NOTES

## RELATED LINKS
