---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAlertAck

## SYNOPSIS
Creates a new alert acknowledgment in LogicMonitor.

## SYNTAX

```
New-LMAlertAck [-Ids] <String[]> [-Note] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAlertAck function is used to create a new alert acknowledgment in LogicMonitor.
It sends a POST request to the LogicMonitor API to acknowledge one or more alerts.

## EXAMPLES

### EXAMPLE 1
```
New-LMAlertAck -Ids @("12345","67890") -Note "Acknowledging alerts"
```

This example acknowledges the alerts with the IDs "12345" and "67890" and adds the note "Acknowledging alerts" to the acknowledgment.

## PARAMETERS

### -Ids
Specifies the alert IDs to be acknowledged.
This parameter is mandatory and accepts an array of strings.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases: Id

Required: True
Position: 1
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Note
Specifies the note to be added to the acknowledgment.
This parameter is mandatory and accepts a string.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
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
This function requires a valid API authentication.
Make sure you are logged in before running any commands by using the Connect-LMAccount function.

## RELATED LINKS
