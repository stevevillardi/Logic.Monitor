---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAlertEscalation

## SYNOPSIS
Creates a new escalation for a LogicMonitor alert.

## SYNTAX

```
New-LMAlertEscalation [-Id] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAlertEscalation function creates a new escalation for a LogicMonitor alert.
It checks if the user is logged in and has valid API credentials before making the API request to create the escalation.

## EXAMPLES

### EXAMPLE 1
```
New-LMAlertEscalation -Id "DS12345"
Creates a new escalation for the alert with ID "12345".
```

## PARAMETERS

### -Id
The ID of the alert for which the escalation needs to be created.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
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
