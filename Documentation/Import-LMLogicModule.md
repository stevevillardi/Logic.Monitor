---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMLogicModule

## SYNOPSIS
Imports a LogicModule into LogicMonitor.

## SYNTAX

### FilePath
```
Import-LMLogicModule -FilePath <String> [-Type <String>] [-ForceOverwrite <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### File
```
Import-LMLogicModule -File <Object> [-Type <String>] [-ForceOverwrite <Boolean>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMLogicModule function imports a LogicModule into LogicMonitor.
It can import the LogicModule from a file path or directly from file data.
The LogicModule can be of different types such as datasource, propertyrules, eventsource, topologysource, or configsource.

## EXAMPLES

### EXAMPLE 1
```
Import-LMLogicModule -FilePath "C:\LogicModules\datasource.xml" -Type "datasource" -ForceOverwrite $true
Imports a datasource LogicModule from the file 'datasource.xml' located in the 'C:\LogicModules' directory. If a LogicModule with the same name already exists, it will be overwritten.
```

### EXAMPLE 2
```
Import-LMLogicModule -File $fileData -Type "propertyrules"
Imports a propertyrules LogicModule using the file data provided in the $fileData variable. If a LogicModule with the same name already exists, an error will be thrown.
```

## PARAMETERS

### -FilePath
Specifies the path of the file containing the LogicModule to import.
This parameter is mandatory when using the 'FilePath' parameter set.

```yaml
Type: String
Parameter Sets: FilePath
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Specifies the file data of the LogicModule to import.
This parameter is mandatory when using the 'File' parameter set.

```yaml
Type: Object
Parameter Sets: File
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the type of the LogicModule to import.
The valid values are 'datasource', 'propertyrules', 'eventsource', 'topologysource', or 'configsource'.
The default value is 'datasource'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Datasource
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForceOverwrite
Indicates whether to overwrite an existing LogicModule with the same name.
If set to $true, the existing LogicModule will be overwritten.
If set to $false, an error will be thrown if a LogicModule with the same name already exists.
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
This function requires PowerShell version 6.1 or higher to run.

## RELATED LINKS
