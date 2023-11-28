---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAPIToken

## SYNOPSIS
Get list of a specifc or list of available API tokens

## SYNTAX

### All (Default)
```
Get-LMAPIToken [-Type <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### AdminId
```
Get-LMAPIToken [-AdminId <Int32>] [-Type <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Id
```
Get-LMAPIToken [-Id <Int32>] [-Type <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### AccessId
```
Get-LMAPIToken [-AccessId <String>] [-Type <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Filter
```
Get-LMAPIToken [-Filter <Object>] [-Type <String>] [-BatchSize <Int32>] [<CommonParameters>]
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

### -AccessId
{{ Fill AccessId Description }}

```yaml
Type: String
Parameter Sets: AccessId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AdminId
{{ Fill AdminId Description }}

```yaml
Type: Int32
Parameter Sets: AdminId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
{{ Fill BatchSize Description }}

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

### -Filter
{{ Fill Filter Description }}

```yaml
Type: Object
Parameter Sets: Filter
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

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
{{ Fill Type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: LMv1, Bearer, *

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
