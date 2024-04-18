---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Invoke-LMCloudGroupNetScan

## SYNOPSIS
Invokes a LogicMonitor Cloud Group NetScan task.

## SYNTAX

### GroupId
```
Invoke-LMCloudGroupNetScan -Id <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName
```
Invoke-LMCloudGroupNetScan -Name <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Invoke-LMCloudGroupNetScan function is used to schedule a LogicMonitor Cloud Group NetScan task.
It requires either the GroupId or GroupName parameter to identify the target device group.

## EXAMPLES

### EXAMPLE 1
```
Invoke-LMCloudGroupNetScan -Id "12345"
Schedules a LogicMonitor Cloud Group NetScan task for the device group with the ID "12345".
```

### EXAMPLE 2
```
Invoke-LMCloudGroupNetScan -Name "MyGroup"
Schedules a LogicMonitor Cloud Group NetScan task for the device group with the name "MyGroup".
```

## PARAMETERS

### -Id
Specifies the ID of the target device group.
This parameter is mandatory when using the 'GroupId' parameter set.

```yaml
Type: String
Parameter Sets: GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the target device group.
This parameter is mandatory when using the 'GroupName' parameter set.

```yaml
Type: String
Parameter Sets: GroupName
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
This function requires a valid LogicMonitor API authentication.
Make sure you are logged in before running any commands using the Connect-LMAccount cmdlet.
You must target a device gropup that belongs to a cloud account (EC2, etc)

## RELATED LINKS
