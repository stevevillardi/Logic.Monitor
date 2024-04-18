---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMCollector

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Id (Default)
```
Set-LMCollector -Id <Int32> [-Description <String>] [-BackupAgentId <Int32>] [-CollectorGroupId <Int32>]
 [-Properties <Hashtable>] [-EnableFailBack <Boolean>] [-EnableFailOverOnCollectorDevice <Boolean>]
 [-EscalatingChainId <Int32>] [-SuppressAlertClear <Boolean>] [-ResendAlertInterval <Int32>]
 [-SpecifiedCollectorDeviceGroupId <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
```

### Name
```
Set-LMCollector -Name <String> [-Description <String>] [-BackupAgentId <Int32>] [-CollectorGroupId <Int32>]
 [-Properties <Hashtable>] [-EnableFailBack <Boolean>] [-EnableFailOverOnCollectorDevice <Boolean>]
 [-EscalatingChainId <Int32>] [-SuppressAlertClear <Boolean>] [-ResendAlertInterval <Int32>]
 [-SpecifiedCollectorDeviceGroupId <Int32>] [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm]
 [<CommonParameters>]
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

### -BackupAgentId
{{ Fill BackupAgentId Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorGroupId
{{ Fill CollectorGroupId Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

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

### -Description
{{ Fill Description Description }}

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

### -EnableFailBack
{{ Fill EnableFailBack Description }}

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

### -EnableFailOverOnCollectorDevice
{{ Fill EnableFailOverOnCollectorDevice Description }}

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

### -EscalatingChainId
{{ Fill EscalatingChainId Description }}

```yaml
Type: Int32
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
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

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

### -Properties
{{ Fill Properties Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResendAlertInterval
{{ Fill ResendAlertInterval Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SpecifiedCollectorDeviceGroupId
{{ Fill SpecifiedCollectorDeviceGroupId Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SuppressAlertClear
{{ Fill SuppressAlertClear Description }}

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

### System.Int32
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
