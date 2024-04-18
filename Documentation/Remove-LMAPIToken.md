---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMAPIToken

## SYNOPSIS
Removes an API token from Logic Monitor.

## SYNTAX

### Id (Default)
```
Remove-LMAPIToken -UserId <Int32> -APITokenId <Int32> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Remove-LMAPIToken -UserName <String> -APITokenId <Int32> [-ProgressAction <ActionPreference>] [-WhatIf]
 [-Confirm] [<CommonParameters>]
```

### AccessId
```
Remove-LMAPIToken -AccessId <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMAPIToken function is used to remove an API token from Logic Monitor.
It supports removing the token by specifying either the token's ID, the user's ID and token's ID, or the user's name and token's ID.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMAPIToken -UserId 1234 -APITokenId 5678
Removes the API token with ID 5678 associated with the user with ID 1234.
```

### EXAMPLE 2
```
Remove-LMAPIToken -UserName "john.doe" -APITokenId 5678
Removes the API token with ID 5678 associated with the user with name "john.doe".
```

### EXAMPLE 3
```
Remove-LMAPIToken -AccessId "abcd1234"
Removes the API token with the specified access ID.
```

## PARAMETERS

### -UserId
The ID of the user associated with the API token.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserName
The name of the user associated with the API token.
This parameter is mandatory when using the 'Name' parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessId
The access ID of the API token.
This parameter is mandatory when using the 'AccessId' parameter set.

```yaml
Type: String
Parameter Sets: AccessId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -APITokenId
The ID of the API token.
This parameter is mandatory when using the 'Id' or 'Name' parameter set.

```yaml
Type: Int32
Parameter Sets: Id, Name
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
Position: Named
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

### You can pipe api token objects to this function.
## OUTPUTS

### A custom object with the following properties:
### - Id: The ID of the removed API token.
### - Message: A message indicating the success of the removal operation.
## NOTES
This function requires a valid API authentication.
Make sure to log in using Connect-LMAccount before running this command.

## RELATED LINKS
