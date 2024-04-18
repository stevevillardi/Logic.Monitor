---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMExchangeModule

## SYNOPSIS
Imports an LM Exchange module.

## SYNTAX

```
Import-LMExchangeModule [-LMExchangeId] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Import-LMExchangeModule function is used to import an LM Exchange module into LogicMonitor.

## EXAMPLES

### EXAMPLE 1
```
Import-LMExchangeModule -LMExchangeId "LM12345"
Imports the LM Exchange module with the ID "LM12345" into LogicMonitor.
```

## PARAMETERS

### -LMExchangeId
The LM Exchange module ID to import.
This parameter is mandatory.

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
