---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMOpsNote

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### All (Default)
```
Set-LMOpsNote -Id <String> [-Note <String>] [-NoteDate <DateTime>] [-Tags <String[]>] [-ClearTags]
 [<CommonParameters>]
```

### Group
```
Set-LMOpsNote -Id <String> [-Note <String>] [-NoteDate <DateTime>] [-Tags <String[]>] [-ClearTags]
 [-DeviceGroupIds <String[]>] [<CommonParameters>]
```

### Resource
```
Set-LMOpsNote -Id <String> [-Note <String>] [-NoteDate <DateTime>] [-Tags <String[]>] [-ClearTags]
 [-WebsiteIds <String[]>] [-DeviceIds <String[]>] [<CommonParameters>]
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

### -ClearTags
{{ Fill ClearTags Description }}

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

### -DeviceGroupIds
{{ Fill DeviceGroupIds Description }}

```yaml
Type: String[]
Parameter Sets: Group
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceIds
{{ Fill DeviceIds Description }}

```yaml
Type: String[]
Parameter Sets: Resource
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
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Note
{{ Fill Note Description }}

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

### -NoteDate
{{ Fill NoteDate Description }}

```yaml
Type: DateTime
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Tags
{{ Fill Tags Description }}

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

### -WebsiteIds
{{ Fill WebsiteIds Description }}

```yaml
Type: String[]
Parameter Sets: Resource
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
