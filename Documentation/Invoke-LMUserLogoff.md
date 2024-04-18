---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMUserLogoff

## SYNOPSIS
Invokes a session logoff for one or more users in Logic Monitor.

## SYNTAX

```
Invoke-LMUserLogoff [-Usernames] <String[]> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMUserLogoff function is used to log off one or more users from a Logic Monitor session.
It checks if the user is logged in and has valid API credentials before making the logoff request.
If the user is not logged in, an error message is displayed.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMUserLogoff -Usernames "user1", "user2"
Invokes a session logoff for the users "user1" and "user2" in Logic Monitor.
```

## PARAMETERS

### -Usernames
Specifies an array of usernames for which the session logoff needs to be invoked.

```yaml
Type: String[]
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
