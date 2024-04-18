---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollectorGroup

## SYNOPSIS
Retrieves collector groups from LogicMonitor.

## SYNTAX

### All (Default)
```
Get-LMCollectorGroup [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMCollectorGroup [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMCollectorGroup [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMCollectorGroup [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollectorGroup function retrieves collector groups from LogicMonitor based on the specified parameters.
It supports retrieving collector groups by ID, name, or using a filter.
The function uses the LogicMonitor REST API to make the requests.

## EXAMPLES

### EXAMPLE 1
```
Get-LMCollectorGroup -Id 123
Retrieves the collector group with the specified ID.
```

### EXAMPLE 2
```
Get-LMCollectorGroup -Name "Group 1"
Retrieves the collector group with the specified name.
```

### EXAMPLE 3
```
Get-LMCollectorGroup -Filter @{ Property = "Value" }
Retrieves collector groups based on the specified filter criteria.
```

## PARAMETERS

### -Id
Specifies the ID of the collector group to retrieve.
This parameter is mutually exclusive with the Name and Filter parameters.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the collector group to retrieve.
This parameter is mutually exclusive with the Id and Filter parameters.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Specifies a filter object to retrieve collector groups based on specific criteria.
This parameter is mutually exclusive with the Id and Name parameters.

```yaml
Type: Object
Parameter Sets: Filter
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
Specifies the number of collector groups to retrieve per request.
The default value is 1000.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1000
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
