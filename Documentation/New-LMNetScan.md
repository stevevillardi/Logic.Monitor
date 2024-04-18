---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMNetScan

## SYNOPSIS
Creates a new network scan in LogicMonitor.

## SYNTAX

```
New-LMNetScan [-CollectorId] <String> [-Name] <String> [[-Description] <String>]
 [[-ExcludeDuplicateType] <String>] [[-IgnoreSystemIpDuplicates] <Boolean>] [[-Method] <String>]
 [[-NextStart] <String>] [[-NextStartEpoch] <String>] [[-NetScanGroupId] <String>] [-SubnetRange] <String>
 [[-CredentialGroupId] <String>] [[-CredentialGroupName] <String>] [[-ChangeNameToken] <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMNetScan function is used to create a new network scan in LogicMonitor.
It sends a POST request to the LogicMonitor API to create the network scan with the specified parameters.

## EXAMPLES

### EXAMPLE 1
```
New-LMNetScan -CollectorId "12345" -Name "MyNetScan" -SubnetRange "192.168.0.0/24"
Creates a new network scan with the specified collector ID, name, and subnet range.
```

## PARAMETERS

### -CollectorId
The ID of the collector to use for the network scan.
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

### -Name
The name of the network scan.
This parameter is mandatory.

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

### -Description
The description of the network scan.

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

### -ExcludeDuplicateType
The type of duplicate exclusion to apply.
The default value is "1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -IgnoreSystemIpDuplicates
Specifies whether to ignore duplicate system IPs.
The default value is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Method
The method to use for the network scan.
Only "nmap" is supported.
The default value is "nmap".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: Nmap
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextStart
The next start time for the network scan.
The default value is "manual".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: Manual
Accept pipeline input: False
Accept wildcard characters: False
```

### -NextStartEpoch
The next start time epoch for the network scan.
The default value is "0".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -NetScanGroupId
The ID of the network scan group to assign the network scan to.
The default value is "1".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -SubnetRange
The subnet range to scan.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CredentialGroupId
The ID of the credential group to use for the network scan.

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

### -CredentialGroupName
The name of the credential group to use for the network scan.

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

### -ChangeNameToken
The token to use for changing the name of discovered devices.
The default value is "##REVERSEDNS##".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: ##REVERSEDNS##
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

## RELATED LINKS
