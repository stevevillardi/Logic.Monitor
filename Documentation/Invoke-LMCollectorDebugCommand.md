---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMCollectorDebugCommand

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Id-Groovy
```
Invoke-LMCollectorDebugCommand -Id <Int32> -GroovyCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [<CommonParameters>]
```

### Id-Posh
```
Invoke-LMCollectorDebugCommand -Id <Int32> -PoshCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [<CommonParameters>]
```

### Id-Debug
```
Invoke-LMCollectorDebugCommand -Id <Int32> -DebugCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [<CommonParameters>]
```

### Name-Groovy
```
Invoke-LMCollectorDebugCommand -Name <String> -GroovyCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [<CommonParameters>]
```

### Name-Posh
```
Invoke-LMCollectorDebugCommand -Name <String> -PoshCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [<CommonParameters>]
```

### Name-Debug
```
Invoke-LMCollectorDebugCommand -Name <String> -DebugCommand <String> [-CommandHostName <String>]
 [-CommandWildValue <String>] [-IncludeResult] [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -CommandHostName
{{ Fill CommandHostName Description }}

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
{{ Fill CommandWildValue Description }}

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

### -DebugCommand
{{ Fill DebugCommand Description }}

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

### -GroovyCommand
{{ Fill GroovyCommand Description }}

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

### -Id
{{ Fill Id Description }}

```yaml
Type: Int32
Parameter Sets: Id-Groovy, Id-Posh, Id-Debug
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IncludeResult
{{ Fill IncludeResult Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

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

### -PoshCommand
{{ Fill PoshCommand Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
