---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMDashboardWidget

## SYNOPSIS
Removes a dashboard widget from Logic Monitor.

## SYNTAX

### Id (Default)
```
Remove-LMDashboardWidget -Id <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Remove-LMDashboardWidget -Name <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMDashboardWidget function removes a dashboard widget from Logic Monitor.
It can remove a widget either by its ID or by its name.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMDashboardWidget -Id 123
Removes the dashboard widget with ID 123.
```

### EXAMPLE 2
```
Remove-LMDashboardWidget -Name "Widget Name"
Removes the dashboard widget with the specified name.
```

## PARAMETERS

### -Id
The ID of the widget to be removed.
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
The name of the widget to be removed.
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

### A PSCustomObject representing the result of the removal operation. The object has the following properties:
### - Id: The ID of the removed widget.
### - Message: A message indicating the success of the removal operation.
## NOTES
This function requires a valid API authentication to Logic Monitor.
Make sure to log in using Connect-LMAccount before running this command.

## RELATED LINKS
