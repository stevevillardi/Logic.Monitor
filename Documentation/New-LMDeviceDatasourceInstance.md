---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceDatasourceInstance

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Name-dsName
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceName <String> -Name <String> [<CommonParameters>]
```

### Id-dsName
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceName <String> -Id <Int32> [<CommonParameters>]
```

### Name-dsId
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceId <Int32> -Name <String> [<CommonParameters>]
```

### Id-dsId
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceId <Int32> -Id <Int32> [<CommonParameters>]
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

### -DatasourceId
{{ Fill DatasourceId Description }}

```yaml
Type: Int32
Parameter Sets: Name-dsId, Id-dsId
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
Parameter Sets: Name-dsName, Id-dsName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{ Fill Description Description }}

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

### -DisableAlerting
{{ Fill DisableAlerting Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisplayName
{{ Fill DisplayName Description }}

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

### -InstanceGroupId
{{ Fill InstanceGroupId Description }}

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

### -Properties
{{ Fill Properties Description }}

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

### -StopMonitoring
{{ Fill StopMonitoring Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WildValue
{{ Fill WildValue Description }}

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

### -WildValue2
{{ Fill WildValue2 Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
