---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDatasourceGraph

## SYNOPSIS
Creates a new datasource graph in LogicMonitor.

## SYNTAX

### dsId
```
New-LMDatasourceGraph -RawObject <Object> -DatasourceId <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### dsName
```
New-LMDatasourceGraph -RawObject <Object> -DatasourceName <Object> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDatasourceGraph function is used to create a new datasource graph in LogicMonitor.
It requires the user to be logged in and have valid API credentials.

## EXAMPLES

### EXAMPLE 1
```
New-LMDatasourceGraph -RawObject $graphConfig -DatasourceId 123
```

### EXAMPLE 2
```
New-LMDatasourceGraph -RawObject $graphConfig -DatasourceName "My Datasource"
```

## PARAMETERS

### -RawObject
Specifies the raw object representing the graph configuration.
This object will be converted to JSON format before sending the request to LogicMonitor.
Use Get-LMDatasourceGraph to get the raw object representing a graph configuration.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceId
Specifies the ID of the datasource to which the graph will be associated.
This parameter is mandatory when using the 'dsId' parameter set.

```yaml
Type: Object
Parameter Sets: dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceName
Specifies the name of the datasource to which the graph will be associated.
This parameter is mandatory when using the 'dsName' parameter set.

```yaml
Type: Object
Parameter Sets: dsName
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

## RELATED LINKS
