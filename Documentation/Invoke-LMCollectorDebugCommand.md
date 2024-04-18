---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMCollectorDebugCommand

## SYNOPSIS
Invokes a debug command on a LogicMonitor collector.

## SYNTAX

### Id-Groovy
```
Invoke-LMCollectorDebugCommand -Id <Int32> -GroovyCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-Posh
```
Invoke-LMCollectorDebugCommand -Id <Int32> -PoshCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-Debug
```
Invoke-LMCollectorDebugCommand -Id <Int32> -DebugCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Groovy
```
Invoke-LMCollectorDebugCommand -Name <String> -GroovyCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Posh
```
Invoke-LMCollectorDebugCommand -Name <String> -PoshCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-Debug
```
Invoke-LMCollectorDebugCommand -Name <String> -DebugCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMCollectorDebugCommand function is used to send a debug command to a LogicMonitor collector.
It supports different parameter sets based on the type of command and the identification method used (ID or name).
The function checks if the user is logged in and has valid API credentials before executing the command.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMCollectorDebugCommand -Id 1234 -DebugCommand "!account" -IncludeResult
Invokes a debug command on the collector with ID 1234 and includes the result.
```

### EXAMPLE 2
```
Invoke-LMCollectorDebugCommand -Name "CollectorName" -PoshCommand "Write-Host 'Hello, World!'" -IncludeResult
Invokes a PowerShell command on the collector with the name "CollectorName" and includes the result.
```

### EXAMPLE 3
```
Invoke-LMCollectorDebugCommand -Id 5678 -GroovyCommand "println 'Hello, World!'" -CommandHostName "Host123"
Invokes a Groovy command on the collector with ID 5678 and specifies the host name as "Host123".
```

## PARAMETERS

### -Id
Specifies the ID of the collector.
This parameter is mandatory for the 'Id-Debug', 'Id-Posh', and 'Id-Groovy' parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-Groovy, Id-Posh, Id-Debug
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the collector.
This parameter is mandatory for the 'Name-Debug', 'Name-Posh', and 'Name-Groovy' parameter sets.

```yaml
Type: String
Parameter Sets: Name-Groovy, Name-Posh, Name-Debug
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DebugCommand
Specifies the debug command to be executed.
This parameter is mandatory for the 'Id-Debug' and 'Name-Debug' parameter sets.

```yaml
Type: String
Parameter Sets: Id-Debug, Name-Debug
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PoshCommand
Specifies the PowerShell command to be executed.
This parameter is mandatory for the 'Id-Posh' and 'Name-Posh' parameter sets.

```yaml
Type: String
Parameter Sets: Id-Posh, Name-Posh
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroovyCommand
Specifies the Groovy command to be executed.
This parameter is mandatory for the 'Id-Groovy' and 'Name-Groovy' parameter sets.

```yaml
Type: String
Parameter Sets: Id-Groovy, Name-Groovy
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CommandHostName
Specifies the host name for the command.
This parameter is optional.

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

### -CommandWildValue
Specifies the wild value for the command.
This parameter is optional.

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

### -IncludeResult
Indicates whether to include the result of the debug command.
This parameter is a switch parameter.

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
LogicMonitor API credentials must be set before running this command.
Use the Connect-LMAccount cmdlet to log in and set the credentials.

## RELATED LINKS
