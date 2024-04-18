---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMCachedAccount

## SYNOPSIS
Removes cached account information from the Logic.Monitor vault.

## SYNTAX

### Single
```
Remove-LMCachedAccount -CachedAccountName <String> [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### All
```
Remove-LMCachedAccount [-RemoveAllEntries] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMCachedAccount function is used to remove cached account information from the Logic.Monitor vault.
It provides two parameter sets: 'Single' and 'All'.
When using the 'Single' parameter set, you can specify a single cached account to remove.
When using the 'All' parameter set, all cached accounts will be removed.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMCachedAccount -CachedAccountName "JohnDoe"
Removes the cached account with the name "JohnDoe" from the Logic.Monitor vault.
```

### EXAMPLE 2
```
Remove-LMCachedAccount -RemoveAllEntries
Removes all cached accounts from the Logic.Monitor vault.
```

## PARAMETERS

### -CachedAccountName
Specifies the name of the cached account to remove.
This parameter is used with the 'Single' parameter set.

```yaml
Type: String
Parameter Sets: Single
Aliases: Portal

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -RemoveAllEntries
Indicates that all cached accounts should be removed.
This parameter is used with the 'All' parameter set.

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: False
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

### You can pipe objects to this function.
## OUTPUTS

## NOTES

## RELATED LINKS
