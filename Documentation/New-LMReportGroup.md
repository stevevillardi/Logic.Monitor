---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMReportGroup

## SYNOPSIS
Creates a new LogicMonitor report group.

## SYNTAX

```
New-LMReportGroup [-Name] <String> [[-Description] <String>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMReportGroup function creates a new report group in LogicMonitor.
It requires the name of the report group as a mandatory parameter and an optional description.

## EXAMPLES

### EXAMPLE 1
```
New-LMReportGroup -Name "MyReportGroup" -Description "This is a sample report group"
```

This example creates a new report group with the name "MyReportGroup" and the description "This is a sample report group".

## PARAMETERS

### -Name
The name of the report group.
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
The description of the report group.
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
This function requires a valid API credential and authentication.
Make sure you are logged in before running any commands using Connect-LMAccount.

## RELATED LINKS
