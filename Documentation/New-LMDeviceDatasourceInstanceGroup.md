---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceDatasourceInstanceGroup

## SYNOPSIS
Creates a new instance group for a LogicMonitor device datasource.

## SYNTAX

### Name-dsName
```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <String> [-Description <String>]
 -DatasourceName <String> -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsName
```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <String> [-Description <String>]
 -DatasourceName <String> -Id <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name-dsId
```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <String> [-Description <String>] -DatasourceId <Int32>
 -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id-dsId
```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName <String> [-Description <String>] -DatasourceId <Int32>
 -Id <Int32> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceDatasourceInstanceGroup function creates a new instance group for a LogicMonitor device datasource.
It requires the user to be logged in and have valid API credentials.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName "Group1" -Description "Instance group for Device1" -DatasourceName "DataSource1" -Name "Device1"
Creates a new instance group named "Group1" with the description "Instance group for Device1" for the device named "Device1" and the datasource named "DataSource1".
```

### EXAMPLE 2
```
New-LMDeviceDatasourceInstanceGroup -InstanceGroupName "Group2" -Description "Instance group for Device2" -DatasourceId 123 -Id 456
Creates a new instance group named "Group2" with the description "Instance group for Device2" for the device with ID 456 and the datasource with ID 123.
```

## PARAMETERS

### -InstanceGroupName
The name of the instance group to create.
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

### -Description
The description of the instance group.

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

### -DatasourceName
The name of the datasource associated with the instance group.
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
The ID of the datasource associated with the instance group.
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
The ID of the device associated with the instance group.
This parameter is mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

```yaml
Type: Int32
Parameter Sets: Id-dsName, Id-dsId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the device associated with the instance group.
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
