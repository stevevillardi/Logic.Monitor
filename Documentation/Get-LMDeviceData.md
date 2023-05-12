---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceData

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### dsName-deviceName-instanceId
```
Get-LMDeviceData -DatasourceName <String> -DeviceName <String> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

### dsName-deviceName-instanceName
```
Get-LMDeviceData -DatasourceName <String> -DeviceName <String> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

### dsName-deviceId-instanceName
```
Get-LMDeviceData -DatasourceName <String> -DeviceId <Int32> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

### dsName-deviceId-instanceId
```
Get-LMDeviceData -DatasourceName <String> -DeviceId <Int32> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

### dsId-deviceName-instanceId
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceName <String> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

### dsId-deviceName-instanceName
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceName <String> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

### dsId-deviceId-instanceName
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceId <Int32> [-InstanceName <String>] [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

### dsId-deviceId-instanceId
```
Get-LMDeviceData -DatasourceId <Int32> -DeviceId <Int32> -InstanceId <Int32> [-StartDate <DateTime>]
 [-EndDate <DateTime>] [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
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

### -DatasourceId
{{ Fill DatasourceId Description }}

```yaml
Type: Int32
Parameter Sets: dsId-deviceName-instanceId, dsId-deviceName-instanceName, dsId-deviceId-instanceName, dsId-deviceId-instanceId
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
Parameter Sets: dsName-deviceName-instanceId, dsName-deviceName-instanceName, dsName-deviceId-instanceName, dsName-deviceId-instanceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
{{ Fill DeviceId Description }}

```yaml
Type: Int32
Parameter Sets: dsName-deviceId-instanceName, dsName-deviceId-instanceId, dsId-deviceId-instanceName, dsId-deviceId-instanceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceName
{{ Fill DeviceName Description }}

```yaml
Type: String
Parameter Sets: dsName-deviceName-instanceId, dsName-deviceName-instanceName, dsId-deviceName-instanceId, dsId-deviceName-instanceName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -EndDate
{{ Fill EndDate Description }}

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

### -Filter
{{ Fill Filter Description }}

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceId
{{ Fill InstanceId Description }}

```yaml
Type: Int32
Parameter Sets: dsName-deviceName-instanceId, dsName-deviceId-instanceId, dsId-deviceName-instanceId, dsId-deviceId-instanceId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceName
{{ Fill InstanceName Description }}

```yaml
Type: String
Parameter Sets: dsName-deviceName-instanceName, dsName-deviceId-instanceName, dsId-deviceName-instanceName, dsId-deviceId-instanceName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StartDate
{{ Fill StartDate Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
