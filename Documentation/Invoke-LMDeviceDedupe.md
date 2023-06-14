---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMDeviceDedupe

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### List
```
Invoke-LMDeviceDedupe [-ListDuplicates] [-DeviceGroupId <String>] [-IpExclusionList <String[]>]
 [-SysNameExclusionList <String[]>] [-ExcludeDeviceType <String[]>] [<CommonParameters>]
```

### Remove
```
Invoke-LMDeviceDedupe [-RemoveDuplicates] [-DeviceGroupId <String>] [-IpExclusionList <String[]>]
 [-SysNameExclusionList <String[]>] [-ExcludeDeviceType <String[]>] [<CommonParameters>]
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

### -DeviceGroupId
{{ Fill DeviceGroupId Description }}

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

### -ExcludeDeviceType
{{ Fill ExcludeDeviceType Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IpExclusionList
{{ Fill IpExclusionList Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ListDuplicates
{{ Fill ListDuplicates Description }}

```yaml
Type: SwitchParameter
Parameter Sets: List
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RemoveDuplicates
{{ Fill RemoveDuplicates Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Remove
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SysNameExclusionList
{{ Fill SysNameExclusionList Description }}

```yaml
Type: String[]
Parameter Sets: (All)
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
