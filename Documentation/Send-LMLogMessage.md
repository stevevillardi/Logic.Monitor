---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Send-LMLogMessage

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### SingleMessage
```
Send-LMLogMessage -Message <String> [-Timestamp <String>] -resourceMapping <Hashtable> [-Metadata <Hashtable>]
 [<CommonParameters>]
```

### MessageList
```
Send-LMLogMessage -MessageArray <Object> [<CommonParameters>]
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

### -Message
{{ Fill Message Description }}

```yaml
Type: String
Parameter Sets: SingleMessage
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -MessageArray
{{ Fill MessageArray Description }}

```yaml
Type: Object
Parameter Sets: MessageList
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Metadata
{{ Fill Metadata Description }}

```yaml
Type: Hashtable
Parameter Sets: SingleMessage
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timestamp
{{ Fill Timestamp Description }}

```yaml
Type: String
Parameter Sets: SingleMessage
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -resourceMapping
{{ Fill resourceMapping Description }}

```yaml
Type: Hashtable
Parameter Sets: SingleMessage
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
