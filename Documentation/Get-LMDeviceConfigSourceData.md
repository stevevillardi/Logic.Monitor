---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceConfigSourceData

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### ListDiffs (Default)
```
Get-LMDeviceConfigSourceData -Id <Int32> -HdsId <String> -HdsInsId <String> [<CommonParameters>]
```

### ConfigId
```
Get-LMDeviceConfigSourceData -Id <Int32> -HdsId <String> -HdsInsId <String> [-ConfigId <String>]
 [<CommonParameters>]
```

### ListConfigs
```
Get-LMDeviceConfigSourceData -Id <Int32> -HdsId <String> -HdsInsId <String> [-LatestConfigOnly]
 [-ConfigType <String>] [<CommonParameters>]
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

### -ConfigId
{{ Fill ConfigId Description }}

```yaml
Type: String
Parameter Sets: ConfigId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigType
{{ Fill ConfigType Description }}

```yaml
Type: String
Parameter Sets: ListConfigs
Aliases:
Accepted values: Delta, Full

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HdsId
{{ Fill HdsId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HdsInsId
{{ Fill HdsInsId Description }}

```yaml
Type: String
Parameter Sets: (All)
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
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LatestConfigOnly
{{ Fill LatestConfigOnly Description }}

```yaml
Type: SwitchParameter
Parameter Sets: ListConfigs
Aliases:

Required: False
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
