---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Remove-LMDeviceDatasourceInstance

## SYNOPSIS
Removes a device datasource instance from Logic Monitor.

## SYNTAX

### Name-dsName
```
Remove-LMDeviceDatasourceInstance -DatasourceName <String> -DeviceName <String> [-WildValue <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsName
```
Remove-LMDeviceDatasourceInstance -DatasourceName <String> -DeviceId <Int32> [-WildValue <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Name-dsId
```
Remove-LMDeviceDatasourceInstance -DatasourceId <Int32> -DeviceName <String> [-WildValue <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

### Id-dsId
```
Remove-LMDeviceDatasourceInstance -DatasourceId <Int32> -DeviceId <Int32> [-WildValue <String>]
 [-ProgressAction <ActionPreference>] [-WhatIf] [-Confirm] [<CommonParameters>]
```

## DESCRIPTION
The Remove-LMDeviceDatasourceInstance function removes a device datasource instance from Logic Monitor.
It requires valid API credentials and the user must be logged in before running this command.

## EXAMPLES

### EXAMPLE 1
```
Remove-LMDeviceDatasourceInstance -DeviceName "MyDevice" -DatasourceName "MyDatasource" -WildValue "12345"
Removes the device datasource instance with the specified device name, datasource name, and wildcard value.
```

### EXAMPLE 2
```
Remove-LMDeviceDatasourceInstance -DeviceId 123 -DatasourceId 456 -WildValue "67890"
Removes the device datasource instance with the specified device ID, datasource ID, and wildcard value.
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
Parameter Sets: Name-dsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: Id-dsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceId
Specifies the ID of the device.
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-dsName
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

```yaml
Type: Int32
Parameter Sets: Id-dsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeviceName
Specifies the name of the device.
This parameter is mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.

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

### -WildValue
Specifies the wildcard value associated with the datasource instance.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -WhatIf
Shows what would happen if the cmdlet runs.
The cmdlet is not run.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: wi

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Confirm
Prompts you for confirmation before running the cmdlet.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: cf

Required: False
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

### None.
## OUTPUTS

### A custom object with the following properties:
### - InstanceId: The ID of the removed instance.
### - Message: A message indicating the success of the removal.
## NOTES

## RELATED LINKS
