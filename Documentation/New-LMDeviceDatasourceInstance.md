---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDeviceDatasourceInstance

## SYNOPSIS
Creates a new instance of a LogicMonitor device datasource.

## SYNTAX

### Name-dsName
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceName <String> -Name <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id-dsName
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceName <String> -Id <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name-dsId
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceId <Int32> -Name <String> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id-dsId
```
New-LMDeviceDatasourceInstance -DisplayName <String> -WildValue <String> [-WildValue2 <String>]
 [-Description <String>] [-Properties <Hashtable>] [-StopMonitoring <Boolean>] [-DisableAlerting <Boolean>]
 [-InstanceGroupId <String>] -DatasourceId <Int32> -Id <Int32> [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The New-LMDeviceDatasourceInstance function creates a new instance of a LogicMonitor device datasource.
It requires valid API credentials and a logged-in session.

## EXAMPLES

### EXAMPLE 1
```
New-LMDeviceDatasourceInstance -DisplayName "Instance 1" -WildValue "Value 1" -Description "This is a new instance" -DatasourceName "DataSource 1" -Name "Host Device 1"
```

This example creates a new instance of a LogicMonitor device datasource with the specified display name, wild value, description, datasource name, and host device name.

## PARAMETERS

### -DisplayName
The display name of the new instance.

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

### -WildValue
The wild value of the new instance.

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
The second wild value of the new instance.

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

### -Description
The description of the new instance.

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

### -Properties
A hashtable of custom properties for the new instance.

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
Specifies whether to stop monitoring the new instance.
Default is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableAlerting
Specifies whether to disable alerting for the new instance.
Default is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceGroupId
The ID of the instance group to which the new instance belongs.

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
The name of the datasource associated with the new instance.
Mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

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
The ID of the datasource associated with the new instance.
Mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

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

### -Id
The ID of the host device associated with the new instance.
Mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

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
The name of the host device associated with the new instance.
Mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.

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
Please ensure you are logged in before running any commands.
Use Connect-LMAccount to login and try again.

## RELATED LINKS
