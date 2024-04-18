---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCachedAccount

## SYNOPSIS
Retrieves information about cached accounts from the Logic.Monitor vault.

## SYNTAX

```
Get-LMCachedAccount [[-CachedAccountName] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCachedAccount function retrieves information about cached accounts from the Logic.Monitor vault.
It returns an array of custom objects containing details such as the cached account name, portal, ID, modified date, and type.

## EXAMPLES

### EXAMPLE 1
```
Get-LMCachedAccount -CachedAccountName "Account1"
Retrieves information for the cached account named "Account1" from the Logic.Monitor vault.
```

### EXAMPLE 2
```
Get-LMCachedAccount
Retrieves information for all cached accounts from the Logic.Monitor vault.
```

## PARAMETERS

### -CachedAccountName
Specifies the name of a specific cached account to retrieve information for.
If not provided, information for all cached accounts will be returned.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
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

### None. You cannot pipe objects to this function.
## OUTPUTS

### System.Object[]
### An array of custom objects representing the cached accounts. Each object contains the following properties:
### - CachedAccountName: The name of the cached account.
### - Portal: The portal associated with the cached account.
### - Id: The ID of the cached account. If not available, "N/A" is displayed.
### - Modified: The modified date of the cached account.
### - Type: The type of the cached account. If not available, "LMv1" is displayed.
## NOTES
This function requires the Get-SecretInfo function from the Logic.Monitor vault.

## RELATED LINKS

[Get-SecretInfo]()

