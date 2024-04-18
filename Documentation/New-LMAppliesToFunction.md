---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMAppliesToFunction

## SYNOPSIS
Creates a new LogicMonitor Applies To function.

## SYNTAX

```
New-LMAppliesToFunction [-Name] <String> [[-Description] <String>] [-AppliesTo] <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMAppliesToFunction function is used to create a new LogicMonitor Applies To function.
It requires the name and applies to parameters, and optionally accepts a description parameter.
The function checks if the user is logged in and has valid API credentials before making the API call to create the function.

## EXAMPLES

### EXAMPLE 1
```
New-LMAppliesToFunction -Name "MyFunction" -AppliesTo "isWindows() && isLinux()"
```

This example creates a new LogicMonitor Applies To function with the name "MyFunction" and the code "return true".

## PARAMETERS

### -Name
The name of the LogicMonitor Applies To function.
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

### -Description
The description of the LogicMonitor Applies To function.
This parameter is optional.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AppliesTo
The code that defines the LogicMonitor Applies To function.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
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
