---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAlertNote

## SYNOPSIS
Creates a new note for one or more LogicMonitor alerts.

## SYNTAX

```
New-LMAlertNote [-Ids] <String[]> [-Note] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAlertNote function creates a new note for one or more LogicMonitor alerts.
It requires the alert IDs and the note content as mandatory parameters.

## EXAMPLES

### EXAMPLE 1
```
New-LMAlertNote -Ids @("12345","67890") -Note "This is a sample note."
```

This example creates a new note with the content "This is a sample note" for the alerts with IDs "12345" and "67890".

## PARAMETERS

### -Ids
Specifies the alert IDs for which the note needs to be created.
This parameter accepts an array of strings.

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
Specifies the content of the note to be created.
This parameter accepts a string.

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

### None. You cannot pipe objects to this function.
## OUTPUTS

### System.String. Returns a success message if the note is created successfully.
## NOTES

## RELATED LINKS
