---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMDeviceConfigSourceCollection

## SYNOPSIS
Invokes a configuration collection task for a LogicMonitor device.

## SYNTAX

### Name-dsName
```
Invoke-LMDeviceConfigSourceCollection -DatasourceName <String> -Name <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
Invoke-LMDeviceConfigSourceCollection -DatasourceName <String> -Id <Int32> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
Invoke-LMDeviceConfigSourceCollection -DatasourceId <Int32> -Name <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
Invoke-LMDeviceConfigSourceCollection -DatasourceId <Int32> -Id <Int32> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-HdsId
```
Invoke-LMDeviceConfigSourceCollection -Id <Int32> -HdsId <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-HdsId
```
Invoke-LMDeviceConfigSourceCollection -Name <String> -HdsId <String> -InstanceId <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMDeviceConfigSourceCollection function is used to schedule a configuration collection task for a LogicMonitor device.
It requires the user to be logged in and have valid API credentials.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMDeviceConfigSourceCollection -Name "MyDevice" -DatasourceName "MyDatasource" -InstanceId "12345"
Schedules a configuration collection task for the device with the name "MyDevice", the datasource with the name "MyDatasource", and the instance with the ID "12345".
```

### EXAMPLE 2
```
Invoke-LMDeviceConfigSourceCollection -Id 123 -DatasourceId 456 -InstanceId "12345"
Schedules a configuration collection task for the device with the ID 123, the datasource with the ID 456, and the instance with the ID "12345".
```

## PARAMETERS

### -DatasourceName
Specifies the name of the datasource.
This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

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

### -DatasourceId
Specifies the ID of the datasource.
This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

```yaml
Type: Int32
Parameter Sets: Name-dsId, Id-dsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the ID of the device.
This parameter is mandatory when using the 'Id-dsId', 'Id-dsName', or 'Id-HdsId' parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId, Id-HdsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the device.
This parameter is mandatory when using the 'Name-dsName', 'Name-dsId', or 'Name-HdsId' parameter sets.

```yaml
Type: String
Parameter Sets: Name-dsName, Name-dsId, Name-HdsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HdsId
Specifies the ID of the host datasource.
This parameter is mandatory when using the 'Id-HdsId' or 'Name-HdsId' parameter sets.

```yaml
Type: String
Parameter Sets: Id-HdsId, Name-HdsId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceId
Specifies the ID of the device instance.
This parameter is mandatory.

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
This function requires the LogicMonitor PowerShell module to be installed.

## RELATED LINKS
