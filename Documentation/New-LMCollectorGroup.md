---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMCollectorGroup

## SYNOPSIS
Creates a new LogicMonitor collector group.

## SYNTAX

```
New-LMCollectorGroup [-Name] <String> [[-Description] <String>] [[-Properties] <Hashtable>]
 [[-AutoBalance] <Boolean>] [[-AutoBalanceInstanceCountThreshold] <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMCollectorGroup function creates a new collector group in LogicMonitor.
It requires a name parameter and supports additional parameters such as description, properties, autoBalance, and autoBalanceInstanceCountThreshold.

## EXAMPLES

### EXAMPLE 1
```
New-LMCollectorGroup -Name "MyCollectorGroup" -Description "This is a new collector group" -Properties @{ "Property1" = "Value1"; "Property2" = "Value2" }
```

This example creates a new collector group named "MyCollectorGroup" with a description and custom properties.

## PARAMETERS

### -Name
The name of the collector group.
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
The description of the collector group.

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

### -Properties
A hashtable of custom properties for the collector group.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoBalance
Specifies whether to enable auto-balancing for the collector group.
The default value is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoBalanceInstanceCountThreshold
The threshold for auto-balancing the collector group.
The default value is 10000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: 10000
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
For this function to work, you need to be logged in with valid API credentials.
Use the Connect-LMAccount function to log in before running this command.

## RELATED LINKS
