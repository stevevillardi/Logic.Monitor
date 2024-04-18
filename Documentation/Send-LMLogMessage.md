---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Send-LMLogMessage

## SYNOPSIS
Sends log messages to LogicMonitor.

## SYNTAX

### SingleMessage
```
Send-LMLogMessage -Message <String> [-Timestamp <String>] -resourceMapping <Hashtable> [-Metadata <Hashtable>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### MessageList
```
Send-LMLogMessage -MessageArray <Object> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Send-LMLogMessage function sends log messages to LogicMonitor for logging and monitoring purposes.
It supports sending a single message or an array of messages.

## EXAMPLES

### EXAMPLE 1
```
Send-LMLogMessage -Message "This is a test log message" -resourceMapping @{ 'system.deviceId' = '12345' } -Metadata @{ 'key1' = 'value1'; 'key2' = 'value2' }
```

Sends a single log message with the specified message, resource mapping, and metadata.

### EXAMPLE 2
```
Send-LMLogMessage -MessageArray $MessageObjectsArray
```

Sends an array of log message objects.

## PARAMETERS

### -Message
Specifies the log message to send.
This parameter is mandatory when using the 'SingleMessage' parameter set.

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

### -Timestamp
Specifies the timestamp for the log message.
If not provided, the current UTC timestamp will be used.
This parameter is mandatory when using the 'SingleMessage' parameter set.

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
Specifies the resource mapping for the log message.
This parameter is mandatory when using the 'SingleMessage' parameter set.

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

### -Metadata
Specifies additional metadata to include with the log message.
This parameter is optional when using the 'SingleMessage' parameter set.

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

### -MessageArray
Specifies an array of log messages to send.
This parameter is mandatory when using the 'MessageList' parameter set.

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
