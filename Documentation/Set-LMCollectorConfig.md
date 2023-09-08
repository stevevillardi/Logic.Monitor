---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMCollectorConfig

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Id-SnippetConf
```
Set-LMCollectorConfig [-Id <Int32>] [-SnmpThreadPool <Int32>] [-SnmpPduTimeout <Int32>]
 [-ScriptThreadPool <Int32>] [-ScriptTimeout <Int32>] [-BatchScriptThreadPool <Int32>]
 [-BatchScriptTimeout <Int32>] [-PowerShellSPSEProcessCountMin <Int32>]
 [-PowerShellSPSEProcessCountMax <Int32>] [-NetflowEnable <Boolean>] [-NbarEnable <Boolean>]
 [-NetflowPorts <String[]>] [-SflowPorts <String[]>] [-LMLogsSyslogEnable <Boolean>]
 [-LMLogsSyslogHostnameFormat <String>] [-LMLogsSyslogPropertyName <String>] [-WaitForRestart]
 [<CommonParameters>]
```

### Id-Conf
```
Set-LMCollectorConfig [-Id <Int32>] [-CollectorSize <String>] [-CollectorConf <String>] [-SbproxyConf <String>]
 [-WatchdogConf <String>] [-WebsiteConf <String>] [-WrapperConf <String>] [-WaitForRestart]
 [<CommonParameters>]
```

### Name-SnippetConf
```
Set-LMCollectorConfig [-Name <String>] [-SnmpThreadPool <Int32>] [-SnmpPduTimeout <Int32>]
 [-ScriptThreadPool <Int32>] [-ScriptTimeout <Int32>] [-BatchScriptThreadPool <Int32>]
 [-BatchScriptTimeout <Int32>] [-PowerShellSPSEProcessCountMin <Int32>]
 [-PowerShellSPSEProcessCountMax <Int32>] [-NetflowEnable <Boolean>] [-NbarEnable <Boolean>]
 [-NetflowPorts <String[]>] [-SflowPorts <String[]>] [-LMLogsSyslogEnable <Boolean>]
 [-LMLogsSyslogHostnameFormat <String>] [-LMLogsSyslogPropertyName <String>] [-WaitForRestart]
 [<CommonParameters>]
```

### Name-Conf
```
Set-LMCollectorConfig [-Name <String>] [-CollectorSize <String>] [-CollectorConf <String>]
 [-SbproxyConf <String>] [-WatchdogConf <String>] [-WebsiteConf <String>] [-WrapperConf <String>]
 [-WaitForRestart] [<CommonParameters>]
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

### -BatchScriptThreadPool
{{ Fill BatchScriptThreadPool Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchScriptTimeout
{{ Fill BatchScriptTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorConf
{{ Fill CollectorConf Description }}

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CollectorSize
{{ Fill CollectorSize Description }}

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:
Accepted values: nano, small, medium, large, extra_large, double_extra_large

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
Parameter Sets: Id-SnippetConf, Id-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LMLogsSyslogEnable
{{ Fill LMLogsSyslogEnable Description }}

```yaml
Type: Boolean
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMLogsSyslogHostnameFormat
{{ Fill LMLogsSyslogHostnameFormat Description }}

```yaml
Type: String
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:
Accepted values: IP, FQDN, HOSTNAME

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMLogsSyslogPropertyName
{{ Fill LMLogsSyslogPropertyName Description }}

```yaml
Type: String
Parameter Sets: Id-SnippetConf, Name-SnippetConf
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
Parameter Sets: Name-SnippetConf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NbarEnable
{{ Fill NbarEnable Description }}

```yaml
Type: Boolean
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowEnable
{{ Fill NetflowEnable Description }}

```yaml
Type: Boolean
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetflowPorts
{{ Fill NetflowPorts Description }}

```yaml
Type: String[]
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PowerShellSPSEProcessCountMax
{{ Fill PowerShellSPSEProcessCountMax Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PowerShellSPSEProcessCountMin
{{ Fill PowerShellSPSEProcessCountMin Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SbproxyConf
{{ Fill SbproxyConf Description }}

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptThreadPool
{{ Fill ScriptThreadPool Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ScriptTimeout
{{ Fill ScriptTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SflowPorts
{{ Fill SflowPorts Description }}

```yaml
Type: String[]
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SnmpPduTimeout
{{ Fill SnmpPduTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SnmpThreadPool
{{ Fill SnmpThreadPool Description }}

```yaml
Type: Int32
Parameter Sets: Id-SnippetConf, Name-SnippetConf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WaitForRestart
{{ Fill WaitForRestart Description }}

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

### -WatchdogConf
{{ Fill WatchdogConf Description }}

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteConf
{{ Fill WebsiteConf Description }}

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WrapperConf
{{ Fill WrapperConf Description }}

```yaml
Type: String
Parameter Sets: Id-Conf, Name-Conf
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

### System.Int32
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
