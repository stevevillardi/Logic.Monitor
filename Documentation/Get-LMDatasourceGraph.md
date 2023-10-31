---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDatasourceGraph

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Id-dsName
```
Get-LMDatasourceGraph -Id <Int32> -DataSourceName <String> [-BatchSize <Int32>] [<CommonParameters>]
```

### Id-dsId
```
Get-LMDatasourceGraph -Id <Int32> -DataSourceId <String> [-BatchSize <Int32>] [<CommonParameters>]
```

### Filter-dsName
```
Get-LMDatasourceGraph -DataSourceName <String> -Filter <Object> [-BatchSize <Int32>] [<CommonParameters>]
```

### Name-dsName
```
Get-LMDatasourceGraph -DataSourceName <String> -Name <String> [-BatchSize <Int32>] [<CommonParameters>]
```

### dsName
```
Get-LMDatasourceGraph -DataSourceName <String> [-BatchSize <Int32>] [<CommonParameters>]
```

### Filter-dsId
```
Get-LMDatasourceGraph -DataSourceId <String> -Filter <Object> [-BatchSize <Int32>] [<CommonParameters>]
```

### Name-dsId
```
Get-LMDatasourceGraph -DataSourceId <String> -Name <String> [-BatchSize <Int32>] [<CommonParameters>]
```

### dsId
```
Get-LMDatasourceGraph -DataSourceId <String> [-BatchSize <Int32>] [<CommonParameters>]
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

### -DataSourceId
{{ Fill DataSourceId Description }}

```yaml
Type: String
Parameter Sets: Id-dsId, Filter-dsId, Name-dsId, dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DataSourceName
{{ Fill DataSourceName Description }}

```yaml
Type: String
Parameter Sets: Id-dsName, Filter-dsName, Name-dsName, dsName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
{{ Fill Filter Description }}

```yaml
Type: Object
Parameter Sets: Filter-dsName, Filter-dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
{{ Fill Id Description }}

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: Name-dsName, Name-dsId
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
