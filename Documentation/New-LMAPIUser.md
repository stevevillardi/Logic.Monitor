---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAPIUser

## SYNOPSIS
Creates a new LogicMonitor API user.

## SYNTAX

```
New-LMAPIUser [-Username] <String> [[-UserGroups] <String[]>] [[-Note] <String>] [[-RoleNames] <String[]>]
 [[-Status] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAPIUser function is used to create a new LogicMonitor API user.
It requires a username and supports optional parameters such as user groups, a note, role names, and status.

## EXAMPLES

### EXAMPLE 1
```
New-LMAPIUser -Username "john.doe" -UserGroups @("Group1","Group2") -Note "Test user" -RoleNames "admin" -Status "active"
```

This example creates a new API user with the username "john.doe", adds the user to "Group1" and "Group2" user groups, adds a note "Test user", assigns the "admin" role, and sets the status to "active".

## PARAMETERS

### -Username
Specifies the username for the new API user.
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

### -UserGroups
Specifies an array of user groups to which the new API user should be added.
This parameter is optional.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Note
Specifies a note for the new API user.
This parameter is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleNames
Specifies an array of role names for the new API user.
The default value is "readonly".
This parameter is optional.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: @("readonly")
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
Specifies the status of the new API user.
Valid values are "active" and "suspended".
The default value is "active".
This parameter is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: Active
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
This function requires a valid API session.
Make sure to log in using the Connect-LMAccount function before running this command.

## RELATED LINKS
