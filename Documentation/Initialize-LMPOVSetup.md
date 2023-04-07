---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Initialize-LMPOVSetup

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Individual
```
Initialize-LMPOVSetup [-Website <String>] [-WebsiteHttpType <String>] [-PortalMetricsAPIUsername <String>]
 [-LogsAPIUsername <String>] [-SetupWebsite] [-SetupPortalMetrics] [-MoveMinimalMonitoring]
 [-CleanupDynamicGroups] [-SetupWindowsLMLogs] [-SetupCollectorServiceInsight]
 [-WindowsLMLogsEventChannels <String>] [<CommonParameters>]
```

### All
```
Initialize-LMPOVSetup [-Website <String>] [-WebsiteHttpType <String>] [-PortalMetricsAPIUsername <String>]
 [-LogsAPIUsername <String>] [-WindowsLMLogsEventChannels <String>] [-RunAll] [<CommonParameters>]
```

### PostPOV-Readonly
```
Initialize-LMPOVSetup [-ReadOnlyMode] [<CommonParameters>]
```

### PostPOV-RevertReadonly
```
Initialize-LMPOVSetup [-RevertReadOnlyMode] [<CommonParameters>]
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

### -CleanupDynamicGroups
{{ Fill CleanupDynamicGroups Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogsAPIUsername
{{ Fill LogsAPIUsername Description }}

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MoveMinimalMonitoring
{{ Fill MoveMinimalMonitoring Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PortalMetricsAPIUsername
{{ Fill PortalMetricsAPIUsername Description }}

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReadOnlyMode
{{ Fill ReadOnlyMode Description }}

```yaml
Type: SwitchParameter
Parameter Sets: PostPOV-Readonly
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RevertReadOnlyMode
{{ Fill RevertReadOnlyMode Description }}

```yaml
Type: SwitchParameter
Parameter Sets: PostPOV-RevertReadonly
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RunAll
{{ Fill RunAll Description }}

```yaml
Type: SwitchParameter
Parameter Sets: All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupCollectorServiceInsight
{{ Fill SetupCollectorServiceInsight Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupPortalMetrics
{{ Fill SetupPortalMetrics Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupWebsite
{{ Fill SetupWebsite Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SetupWindowsLMLogs
{{ Fill SetupWindowsLMLogs Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Individual
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Website
{{ Fill Website Description }}

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteHttpType
{{ Fill WebsiteHttpType Description }}

```yaml
Type: String
Parameter Sets: Individual, All
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsLMLogsEventChannels
{{ Fill WindowsLMLogsEventChannels Description }}

```yaml
Type: String
Parameter Sets: Individual, All
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
