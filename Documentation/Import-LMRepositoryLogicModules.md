---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMRepositoryLogicModules

## SYNOPSIS
Imports LogicMonitor repository logic modules.

## SYNTAX

```
Import-LMRepositoryLogicModules [-Type] <String> [-LogicModuleNames] <String[]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMRepositoryLogicModules function imports logic modules from the LogicMonitor repository.
It requires the user to be logged in and have valid API credentials.

## EXAMPLES

### EXAMPLE 1
```
Import-LMRepositoryLogicModules -Type "datasources" -LogicModuleNames "DataSource1", "DataSource2"
Imports the logic modules with the names "DataSource1" and "DataSource2" from the LogicMonitor repository.
```

## PARAMETERS

### -Type
Specifies the type of logic modules to import.
Valid values are "datasources", "propertyrules", "eventsources", "topologysources", and "configsources".

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

### -LogicModuleNames
Specifies the names of the logic modules to import.
This parameter accepts an array of strings.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Name

Required: True
Position: 2
Default value: None
Accept pipeline input: True (ByPropertyName)
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

## RELATED LINKS
