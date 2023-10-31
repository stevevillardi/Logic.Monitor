---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Send-LMPushMetric

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Create-DatasourceName
```
Send-LMPushMetric [-NewResourceHostName <String>] [-NewResourceDescription <String>] -ResourceIds <Hashtable>
 [-ResourceProperties <Hashtable>] -DatasourceName <String> [-DatasourceDisplayName <String>]
 [-DatasourceGroup <String>] -Instances <System.Collections.Generic.List`1[System.Object]> [<CommonParameters>]
```

### Create-DatasourceId
```
Send-LMPushMetric [-NewResourceHostName <String>] [-NewResourceDescription <String>] -ResourceIds <Hashtable>
 [-ResourceProperties <Hashtable>] -DatasourceId <String> [-DatasourceDisplayName <String>]
 [-DatasourceGroup <String>] -Instances <System.Collections.Generic.List`1[System.Object]> [<CommonParameters>]
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

### -DatasourceDisplayName
{{ Fill DatasourceDisplayName Description }}

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

### -DatasourceGroup
{{ Fill DatasourceGroup Description }}

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

### -DatasourceId
{{ Fill DatasourceId Description }}

```yaml
Type: String
Parameter Sets: Create-DatasourceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DatasourceName
{{ Fill DatasourceName Description }}

```yaml
Type: String
Parameter Sets: Create-DatasourceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Instances
{{ Fill Instances Description }}

```yaml
Type: System.Collections.Generic.List`1[System.Object]
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewResourceDescription
{{ Fill NewResourceDescription Description }}

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

### -NewResourceHostName
{{ Fill NewResourceHostName Description }}

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

### -ResourceIds
{{ Fill ResourceIds Description }}

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourceProperties
{{ Fill ResourceProperties Description }}

```yaml
Type: Hashtable
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
