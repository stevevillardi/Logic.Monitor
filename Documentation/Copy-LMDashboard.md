---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Copy-LMDashboard

## SYNOPSIS
Copies a LogicMonitor dashboard to a new dashboard.

## SYNTAX

### GroupName-Id
```
Copy-LMDashboard -Name <String> -DashboardId <String> [-Description <String>] -ParentGroupName <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupId-Id
```
Copy-LMDashboard -Name <String> -DashboardId <String> [-Description <String>] -ParentGroupId <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName-Name
```
Copy-LMDashboard -Name <String> -DashboardName <String> [-Description <String>] -ParentGroupName <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupId-Name
```
Copy-LMDashboard -Name <String> -DashboardName <String> [-Description <String>] -ParentGroupId <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Copy-LMDashboard function allows you to copy a LogicMonitor dashboard to a new dashboard.
You can specify the name, ID, or group name of the dashboard to be copied, as well as provide a new name and optional description for the copied dashboard.
The function requires valid API credentials and a logged-in session.

## EXAMPLES

### EXAMPLE 1
```
Copy-LMDashboard -Name "New Dashboard" -DashboardId 12345 -ParentGroupId 67890
Copies the dashboard with ID 12345 to a new dashboard named "New Dashboard" in the group with ID 67890.
```

### EXAMPLE 2
```
Copy-LMDashboard -Name "New Dashboard" -DashboardName "Old Dashboard" -ParentGroupName "Group A"
Copies the dashboard named "Old Dashboard" to a new dashboard named "New Dashboard" in the group named "Group A".
```

## PARAMETERS

### -Name
The name of the new dashboard.

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

### -DashboardId
The ID of the dashboard to be copied.
This parameter is mandatory when using the 'GroupId-Id' or 'GroupName-Id' parameter sets.

```yaml
Type: String
Parameter Sets: GroupName-Id, GroupId-Id
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -DashboardName
The name of the dashboard to be copied.
This parameter is mandatory when using the 'GroupId-Name' or 'GroupName-Name' parameter sets.

```yaml
Type: String
Parameter Sets: GroupName-Name, GroupId-Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
An optional description for the new dashboard.

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

### -ParentGroupId
The ID of the parent group for the new dashboard.
This parameter is mandatory when using the 'GroupId-Id' or 'GroupId-Name' parameter sets.

```yaml
Type: Int32
Parameter Sets: GroupId-Id, GroupId-Name
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
The name of the parent group for the new dashboard.
This parameter is mandatory when using the 'GroupName-Id' or 'GroupName-Name' parameter sets.

```yaml
Type: String
Parameter Sets: GroupName-Id, GroupName-Name
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
Ensure that you are logged in before running any commands by using the Connect-LMAccount cmdlet.

## RELATED LINKS
