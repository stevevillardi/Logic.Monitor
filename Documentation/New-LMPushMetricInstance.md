---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMPushMetricInstance

## SYNOPSIS
Creates a new instance of a LogicMonitor push metric.

## SYNTAX

```
New-LMPushMetricInstance [[-InstancesArrary] <System.Collections.Generic.List`1[System.Object]>]
 [-InstanceName] <String> [[-InstanceDisplayName] <String>] [[-InstanceDescription] <String>]
 [[-InstanceProperties] <Hashtable>] [-Datapoints] <System.Collections.Generic.List`1[System.Object]>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMPushMetricInstance function is used to create a new instance of a LogicMonitor push metric.
It adds the instance to the specified instances array and returns the updated array.

## EXAMPLES

### EXAMPLE 1
```
$instances = New-LMPushMetricInstance -InstancesArrary $instances -InstanceName "Instance1" -InstanceDisplayName "Instance 1" -InstanceDescription "This is instance 1" -InstanceProperties @{Property1 = "Value1"; Property2 = "Value2"} -Datapoints $datapoints
```

This example creates a new instance with the specified parameters and adds it to the existing instances array.

## PARAMETERS

### -InstancesArrary
The array of existing instances to which the new instance will be added.

```yaml
Type: System.Collections.Generic.List`1[System.Object]
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceName
The name of the new instance.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceDisplayName
The display name of the new instance.
If not specified, the InstanceName will be used as the display name.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceDescription
The description of the new instance.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -InstanceProperties
A hashtable containing additional properties for the new instance.

```yaml
Type: Hashtable
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Datapoints
The list of datapoints associated with the new instance.
Datapoints should be the results of the New-LMPushMetricDataPoint function.

```yaml
Type: System.Collections.Generic.List`1[System.Object]
Parameter Sets: (All)
Aliases:

Required: True
Position: 6
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
Ensure that you are logged in before running any commands by using the Connect-LMAccount cmdlet.

## RELATED LINKS
