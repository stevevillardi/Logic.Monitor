---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Send-LMPushMetric

## SYNOPSIS
Sends a push metric to LogicMonitor.

## SYNTAX

### Create-DatasourceName
```
Send-LMPushMetric [-NewResourceHostName <String>] [-NewResourceDescription <String>] -ResourceIds <Hashtable>
 [-ResourceProperties <Hashtable>] -DatasourceName <String> [-DatasourceDisplayName <String>]
 [-DatasourceGroup <String>] -Instances <System.Collections.Generic.List`1[System.Object]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Create-DatasourceId
```
Send-LMPushMetric [-NewResourceHostName <String>] [-NewResourceDescription <String>] -ResourceIds <Hashtable>
 [-ResourceProperties <Hashtable>] -DatasourceId <String> [-DatasourceDisplayName <String>]
 [-DatasourceGroup <String>] -Instances <System.Collections.Generic.List`1[System.Object]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Send-LMPushMetric function sends a push metric to LogicMonitor.
It allows you to create a new resource or update an existing resource with the specified metric data.

## EXAMPLES

### EXAMPLE 1
```
Send-LMPushMetric -NewResourceHostName "NewResource" -NewResourceDescription "New Resource Description" -ResourceIds @{"system.deviceId"="12345"} -ResourceProperties @{"Property1"="Value1"; "Property2"="Value2"} -DatasourceId "123" -Instances $Instances
```

This example sends a push metric to LogicMonitor by creating a new resource with the specified hostname and description.
It updates the resource properties and associates it with the specified datasource ID.
The metric data is sent for the specified instances.

## PARAMETERS

### -NewResourceHostName
Specifies the hostname of the new resource to be created.
This parameter is required if you want to create a new resource.

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

### -NewResourceDescription
Specifies the description of the new resource to be created.
This parameter is required if you want to create a new resource.

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
Specifies the resource IDs to use for resource mapping.
This parameter is mandatory.

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
Specifies the properties of the resources to be updated.
This parameter is optional.

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

### -DatasourceId
Specifies the ID of the datasource.
This parameter is required if the datasource name is not specified.

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
Specifies the name of the datasource.
This parameter is required if the datasource ID is not specified.

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

### -DatasourceDisplayName
Specifies the display name of the datasource.
This parameter is optional and defaults to the datasource name if not specified.

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
Specifies the group of the datasource.
This parameter is optional and defaults to "PushModules" if not specified.

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

### -Instances
Specifies the instances of the resources to be updated.
This parameter is mandatory.
The instances should be the results of the New-LMPushMetricInstance function.

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
This function requires a valid API authentication.
Make sure you are logged in before running any commands using Connect-LMAccount.

## RELATED LINKS
