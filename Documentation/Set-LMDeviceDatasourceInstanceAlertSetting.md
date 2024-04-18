---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMDeviceDatasourceInstanceAlertSetting

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Name-dsName
```
Set-LMDeviceDatasourceInstanceAlertSetting -DatasourceName <String> -Name <String> -DatapointName <String>
 -InstanceName <String> [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName
```
Set-LMDeviceDatasourceInstanceAlertSetting -DatasourceName <String> -Id <Int32> -DatapointName <String>
 -InstanceName <String> [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId
```
Set-LMDeviceDatasourceInstanceAlertSetting -DatasourceId <Int32> -Name <String> -DatapointName <String>
 -InstanceName <String> [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId
```
Set-LMDeviceDatasourceInstanceAlertSetting -DatasourceId <Int32> -Id <Int32> -DatapointName <String>
 -InstanceName <String> [-DisableAlerting <Boolean>] [-AlertExpressionNote <String>] -AlertExpression <String>
 -AlertClearTransitionInterval <Int32> -AlertTransitionInterval <Int32> -AlertForNoData <Int32>
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
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

### -AlertClearTransitionInterval
{{ Fill AlertClearTransitionInterval Description }}

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

### -AlertExpression
{{ Fill AlertExpression Description }}

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

### -AlertExpressionNote
{{ Fill AlertExpressionNote Description }}

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

### -AlertForNoData
{{ Fill AlertForNoData Description }}

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

### -AlertTransitionInterval
{{ Fill AlertTransitionInterval Description }}

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

### -DatapointName
{{ Fill DatapointName Description }}

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

### -DatasourceId
{{ Fill DatasourceId Description }}

```yaml
Type: Int32
Parameter Sets: Name-dsId, Id-dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceName
{{ Fill DatasourceName Description }}

```yaml
Type: String
Parameter Sets: Name-dsName, Id-dsName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAlerting
{{ Fill DisableAlerting Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId
Aliases: DeviceId

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceName
{{ Fill InstanceName Description }}

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

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: Name-dsName, Name-dsId
Aliases: DeviceName

Required: True
Position: Named
Default value: None
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
