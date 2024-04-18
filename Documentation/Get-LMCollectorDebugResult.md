---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollectorDebugResult

## SYNOPSIS
Retrieves the debug result for a LogicMonitor collector.

## SYNTAX

### Id
```
Get-LMCollectorDebugResult -SessionId <Int32> -Id <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMCollectorDebugResult -SessionId <Int32> -Name <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollectorDebugResult function retrieves the debug result for a LogicMonitor collector based on the specified session ID, collector ID, or collector name.

## EXAMPLES

### EXAMPLE 1
```
Get-LMCollectorDebugResult -SessionId 12345 -Id 67890
Retrieves the debug result for the collector with ID 67890 in the debug session with ID 12345.
```

### EXAMPLE 2
```
Get-LMCollectorDebugResult -SessionId 12345 -Name "Collector1"
Retrieves the debug result for the collector with name "Collector1" in the debug session with ID 12345.
```

## PARAMETERS

### -SessionId
The session ID of the debug session.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
The ID of the collector.
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

### -Name
The name of the collector.
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
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this command.

## RELATED LINKS
