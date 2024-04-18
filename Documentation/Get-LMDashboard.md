---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDashboard

## SYNOPSIS
Retrieves LogicMonitor dashboards based on specified parameters.

## SYNTAX

### All (Default)
```
Get-LMDashboard [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMDashboard [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMDashboard [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupId
```
Get-LMDashboard [-GroupId <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### GroupName
```
Get-LMDashboard [-GroupName <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### SubGroups
```
Get-LMDashboard [-GroupPathSearchString <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMDashboard [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMDashboard function retrieves LogicMonitor dashboards based on the specified parameters.
It supports filtering by ID, name, group ID, group name, subgroups, and custom filters.
The function uses the LogicMonitor REST API to make the requests.

## EXAMPLES

### EXAMPLE 1
```
Get-LMDashboard -Id 123
Retrieves the dashboard with the specified ID.
```

### EXAMPLE 2
```
Get-LMDashboard -Name "My Dashboard"
Retrieves the dashboard with the specified name.
```

### EXAMPLE 3
```
Get-LMDashboard -GroupId 456
Retrieves the dashboards that belong to the group with the specified ID.
```

### EXAMPLE 4
```
Get-LMDashboard -GroupName "My Group"
Retrieves the dashboards that belong to the group with the specified name.
```

### EXAMPLE 5
```
Get-LMDashboard -GroupPathSearchString "Subgroup"
Retrieves the dashboards that belong to subgroups matching the specified search string.
```

### EXAMPLE 6
```
Get-LMDashboard -Filter @{Property1 = "Value1"; Property2 = "Value2"}
Retrieves the dashboards that match the specified custom filter.
```

## PARAMETERS

### -Id
Specifies the ID of the dashboard to retrieve.

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
Specifies the name of the dashboard to retrieve.

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

### -GroupId
Specifies the ID of the group to filter the dashboards by.

```yaml
Type: String
Parameter Sets: GroupId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupName
Specifies the name of the group to filter the dashboards by.

```yaml
Type: String
Parameter Sets: GroupName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupPathSearchString
Specifies a search string to filter the dashboards by group path.

```yaml
Type: String
Parameter Sets: SubGroups
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Specifies a custom filter to apply to the dashboards.
The filter should be an object that contains the filter properties.

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
Specifies the number of dashboards to retrieve in each request.
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
This function requires a valid LogicMonitor API authentication.
Use Connect-LMAccount to authenticate before running this function.

## RELATED LINKS
