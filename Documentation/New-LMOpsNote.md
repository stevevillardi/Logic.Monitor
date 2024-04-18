---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMOpsNote

## SYNOPSIS
Creates a new LogicMonitor OpsNote.

## SYNTAX

```
New-LMOpsNote [-Note] <String> [[-NoteDate] <DateTime>] [[-Tags] <String[]>] [[-DeviceGroupIds] <String[]>]
 [[-WebsiteIds] <String[]>] [[-DeviceIds] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMOpsNote function is used to create a new OpsNote in LogicMonitor.
OpsNotes are used to document important information or events related to monitoring.

## EXAMPLES

### EXAMPLE 1
```
New-LMOpsNote -Note "Server maintenance scheduled for tomorrow" -NoteDate (Get-Date).AddDays(1) -Tags "maintenance", "server"
```

This example creates a new OpsNote with the content "Server maintenance scheduled for tomorrow" and a note date set to tomorrow.
It also associates the tags "maintenance" and "server" with the OpsNote.

## PARAMETERS

### -Note
Specifies the content of the OpsNote.
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

### -NoteDate
Specifies the date and time of the OpsNote.
If not provided, the current date and time will be used.

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
Specifies an array of tags to associate with the OpsNote.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceGroupIds
Specifies an array of device group IDs to associate with the OpsNote.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteIds
Specifies an array of website IDs to associate with the OpsNote.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceIds
Specifies an array of device IDs to associate with the OpsNote.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
LogicMonitor API credentials must be set before using this function.
Use the Connect-LMAccount function to log in and set the credentials.

## RELATED LINKS
