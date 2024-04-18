---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAPIToken

## SYNOPSIS
Creates a new LogicMonitor API token.

## SYNTAX

### Id
```
New-LMAPIToken -Id <String[]> [-Note <String>] [-CreateDisabled] [-Type <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Username
```
New-LMAPIToken -Username <String> [-Note <String>] [-CreateDisabled] [-Type <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAPIToken function is used to create a new LogicMonitor API token.
It requires the user to be logged in and have valid API credentials.
The function supports two parameter sets: 'Id' and 'Username'.
The 'Id' parameter set is used to specify the user ID for which the API token will be created.
The 'Username' parameter set is used to specify the username for which the API token will be created.
The function also supports additional parameters such as 'Note', 'CreateDisabled', and 'Type'.

## EXAMPLES

### EXAMPLE 1
```
New-LMAPIToken -Id "12345" -Note "API Token for user 12345"
```

### EXAMPLE 2
```
New-LMAPIToken -Username "john.doe" -Note "API Token for user john.doe" -CreateDisabled
```

## PARAMETERS

### -Id
Specifies the user ID for which the API token will be created.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: String[]
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Username
Specifies the username for which the API token will be created.
This parameter is mandatory when using the 'Username' parameter set.

```yaml
Type: String
Parameter Sets: Username
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Note
Specifies a note for the API token.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreateDisabled
Specifies whether the API token should be created in a disabled state.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
Specifies the type of API token to create.
Valid values are 'LMv1' and 'Bearer'.
The default value is 'LMv1'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: LMv1
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
This function requires the user to be logged in and have valid API credentials.
Use the Connect-LMAccount function to log in before running any commands.

## RELATED LINKS
