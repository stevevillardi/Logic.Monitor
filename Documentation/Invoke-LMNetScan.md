---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMNetScan

## SYNOPSIS
Invokes a NetScan task in LogicMonitor.

## SYNTAX

```
Invoke-LMNetScan [-Id] <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMNetScan function is used to execute a NetScan task in LogicMonitor.
It checks if the user is logged in and has valid API credentials before making the API call.
If the user is logged in, it builds the necessary headers and URI, and then issues a GET request to execute the NetScan task.
If the request is successful, it returns a message indicating that the NetScan task has been scheduled.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMNetScan -Id "12345"
Schedules the NetScan task with ID "12345" in LogicMonitor.
```

## PARAMETERS

### -Id
The ID of the NetScan task to be executed.
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
