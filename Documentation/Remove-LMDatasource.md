---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMDatasource

## SYNOPSIS
Removes a LogicMonitor datasource.

## SYNTAX

### Id (Default)
```
Remove-LMDatasource -Id <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name
```
Remove-LMDatasource -Name <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### DisplayName
```
Remove-LMDatasource -DisplayName <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMDatasource function removes a LogicMonitor datasource based on the specified parameters.
It requires the user to be logged in and have valid API credentials.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMDatasource -Id 123
Removes the datasource with the ID 123.
```

### EXAMPLE 2
```
Remove-LMDatasource -Name "MyDatasource"
Removes the datasource with the name "MyDatasource".
```

### EXAMPLE 3
```
Remove-LMDatasource -DisplayName "My Datasource"
Removes the datasource with the display name "My Datasource".
```

## PARAMETERS

### -Id
Specifies the ID of the datasource to be removed.
This parameter is mandatory and can be provided as an integer.

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
Specifies the name of the datasource to be removed.
This parameter is mandatory when using the 'Name' parameter set and can be provided as a string.

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

### -DisplayName
Specifies the display name of the datasource to be removed.
This parameter is mandatory when using the 'DisplayName' parameter set and can be provided as a string.

```yaml
Type: String
Parameter Sets: DisplayName
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
## NOTES

## RELATED LINKS
