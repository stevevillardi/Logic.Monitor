---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMEnhancedNetScan

## SYNOPSIS
Creates a new enhanced network scan in LogicMonitor.

## SYNTAX

```
New-LMEnhancedNetScan [-CollectorId] <String> [-Name] <String> [[-NetScanGroupName] <String>]
 [[-CustomCredentials] <System.Collections.Generic.List`1[System.Management.Automation.PSObject]>]
 [[-Filters] <System.Collections.Generic.List`1[System.Management.Automation.PSObject]>]
 [[-Description] <String>] [[-ExcludeDuplicateType] <String>] [[-Method] <String>] [[-NextStart] <String>]
 [[-NextStartEpoch] <String>] [[-GroovyScript] <String>] [[-CredentialGroupId] <String>]
 [[-CredentialGroupName] <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMEnhancedNetScan function creates a new enhanced network scan in LogicMonitor.
It allows you to specify various parameters such as the collector ID, name, net scan group name, custom credentials, filters, description, exclude duplicate type, method, next start, next start epoch, Groovy script, credential group ID, and credential group name.

## EXAMPLES

### EXAMPLE 1
```
New-LMEnhancedNetScan -CollectorId "12345" -Name "MyNetScan" -NetScanGroupName "Group1" -CustomCredentials $customCreds -Filters $filters -Description "This is a network scan" -ExcludeDuplicateType "1" -Method "enhancedScript" -NextStart "manual" -NextStartEpoch "0" -GroovyScript "script" -CredentialGroupId "67890" -CredentialGroupName "Group2"
```

This example creates a new enhanced network scan with the specified parameters.

## PARAMETERS

### -CollectorId
The ID of the collector where the network scan will be executed.

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

### -Name
The name of the network scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetScanGroupName
The name of the net scan group.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomCredentials
A list of custom credentials to be used for the network scan.

```yaml
Type: System.Collections.Generic.List`1[System.Management.Automation.PSObject]
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filters
A list of filters to be applied to the network scan.

```yaml
Type: System.Collections.Generic.List`1[System.Management.Automation.PSObject]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
A description of the network scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ExcludeDuplicateType
The type of duplicates to be excluded.
Default value is "1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The method to be used for the network scan.
Default value is "enhancedScript".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: EnhancedScript
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextStart
The next start time for the network scan.
Default value is "manual".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: Manual
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextStartEpoch
The next start epoch for the network scan.
Default value is "0".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroovyScript
The Groovy script to be executed during the network scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CredentialGroupId
The ID of the credential group to be used for the network scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CredentialGroupName
The name of the credential group to be used for the network scan.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
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
For more information about LogicMonitor network scans, refer to the LogicMonitor documentation.

## RELATED LINKS
