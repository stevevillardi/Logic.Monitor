---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMDashboardGroup

## SYNOPSIS
Creates a new LogicMonitor dashboard group.

## SYNTAX

### GroupId
```
New-LMDashboardGroup -Name <String> [-Description <String>] [-WidgetTokens <Hashtable>] -ParentGroupId <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName
```
New-LMDashboardGroup -Name <String> [-Description <String>] [-WidgetTokens <Hashtable>]
 -ParentGroupName <String> [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMDashboardGroup function is used to create a new dashboard group in LogicMonitor.
It requires a name for the group and can optionally include a description, widget tokens, and either the parent group ID or parent group name.

## EXAMPLES

### EXAMPLE 1
```
New-LMDashboardGroup -Name "MyDashboardGroup" -Description "This is a sample dashboard group" -WidgetTokens @{ "Token1" = "Value1"; "Token2" = "Value2" } -ParentGroupId 123
```

This example creates a new dashboard group named "MyDashboardGroup" with a description and widget tokens.
It sets the parent group using the parent group ID.

### EXAMPLE 2
```
New-LMDashboardGroup -Name "MyDashboardGroup" -Description "This is a sample dashboard group" -WidgetTokens @{ "Token1" = "Value1"; "Token2" = "Value2" } -ParentGroupName "ParentGroup"
```

This example creates a new dashboard group named "MyDashboardGroup" with a description and widget tokens.
It sets the parent group using the parent group name.

## PARAMETERS

### -Name
The name of the dashboard group.
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
The description of the dashboard group.
This parameter is optional.

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

### -WidgetTokens
A hashtable containing widget tokens.
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

### -ParentGroupId
The ID of the parent group.
This parameter is mandatory when using the 'GroupId' parameter set.

```yaml
Type: Int32
Parameter Sets: GroupId
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
The name of the parent group.
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
Make sure to log in using the Connect-LMAccount function before running this command.

## RELATED LINKS
