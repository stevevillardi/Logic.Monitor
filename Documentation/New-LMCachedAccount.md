---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMCachedAccount

## SYNOPSIS
Store a connection to a specified LM portal for use with Connect-LMAccount

## SYNTAX

```
New-LMCachedAccount [-AccessId] <String> [-AccessKey] <String> [-AccountName] <String>
 [[-OverwriteExisting] <Boolean>] [<CommonParameters>]
```

## DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands assoicated with the Logic.Monitor PS module.
Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

## EXAMPLES

### EXAMPLE 1
```
New-LMCachedAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain
```

## PARAMETERS

### -AccessId
Access ID from your API credential aquired from the LM Portal

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

### -AccessKey
Access Key from your API credential aquired from the LM Portal

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

### -AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverwriteExisting
{{ Fill OverwriteExisting Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES

## RELATED LINKS
