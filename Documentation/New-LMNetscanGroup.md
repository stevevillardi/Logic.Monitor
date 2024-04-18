---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMNetscanGroup

## SYNOPSIS
Creates a new LogicMonitor Netscan Group.

## SYNTAX

```
New-LMNetscanGroup [-Name] <String> [[-Description] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMNetscanGroup function is used to create a new Netscan Group in LogicMonitor.
It requires the Name parameter, which specifies the name of the group, and the optional Description parameter, which provides a description for the group.

## EXAMPLES

### EXAMPLE 1
```
New-LMNetscanGroup -Name "Group1" -Description "This is a sample group"
```

This example creates a new Netscan Group with the name "Group1" and the description "This is a sample group".

## PARAMETERS

### -Name
Specifies the name of the Netscan Group.
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

### -Description
Specifies the description for the Netscan Group.
This parameter is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
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
