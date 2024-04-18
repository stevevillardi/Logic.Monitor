---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMRole

## SYNOPSIS
Creates a new Logic Monitor role with specified privileges.

## SYNTAX

### Default (Default)
```
New-LMRole -Name <String> [-CustomHelpLabel <String>] [-CustomHelpURL <String>] [-Description <String>]
 [-RequireEULA] [-TwoFARequired <Boolean>] [-RoleGroupId <String>] [-DashboardsPermission <String>]
 [-ResourcePermission <String>] [-LogsPermission <String>] [-WebsitesPermission <String>]
 [-SavedMapsPermission <String>] [-ReportsPermission <String>] [-LMXToolBoxPermission <String>]
 [-LMXPermission <String>] [-SettingsPermission <String>] [-CreatePrivateDashboards] [-AllowWidgetSharing]
 [-ConfigTabRequiresManagePermission] [-AllowedToViewMapsTab] [-AllowedToManageResourceDashboards]
 [-ViewTraces] [-ViewSupport] [-EnableRemoteSessionForResources] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Custom
```
New-LMRole -Name <String> [-CustomHelpLabel <String>] [-CustomHelpURL <String>] [-Description <String>]
 [-RequireEULA] [-TwoFARequired <Boolean>] [-RoleGroupId <String>] -CustomPrivilegesObject <PSObject>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMRole function creates a new Logic Monitor role with the specified privileges and settings.
It allows you to customize various permissions and options for the role.

## EXAMPLES

### EXAMPLE 1
```
New-LMRole -Name "MyRole" -Description "Custom role with limited permissions" -DashboardsPermission "view" -ResourcePermission "manage"
```

This example creates a new Logic Monitor role named "MyRole" with a description and limited permissions for dashboards and resources.

## PARAMETERS

### -Name
Specifies the name of the role.

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

### -CustomHelpLabel
Specifies a custom label for the help button in the Logic Monitor UI.

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

### -CustomHelpURL
Specifies a custom URL for the help button in the Logic Monitor UI.

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
Specifies a description for the role.

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

### -RequireEULA
Indicates whether the user must accept the End User License Agreement (EULA) before using the role.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TwoFARequired
Indicates whether two-factor authentication is required for the role.
Default value is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleGroupId
Specifies the ID of the role group to which the role belongs.
Default value is 1.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: 1
Accept pipeline input: False
Accept wildcard characters: False
```

### -DashboardsPermission
Specifies the permission level for dashboards.
Valid values are "view", "manage", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourcePermission
Specifies the permission level for resources.
Valid values are "view", "manage", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogsPermission
Specifies the permission level for logs.
Valid values are "view", "manage", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsitesPermission
Specifies the permission level for websites.
Valid values are "view", "manage", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SavedMapsPermission
Specifies the permission level for saved maps.
Valid values are "view", "manage", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReportsPermission
Specifies the permission level for reports.
Valid values are "view", "manage", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMXToolBoxPermission
Specifies the permission level for LMX Toolbox.
Valid values are "view", "manage", "commit", "publish", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LMXPermission
Specifies the permission level for LMX.
Valid values are "view", "install", or "none".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingsPermission
Specifies the permission level for settings.
Valid values are "view", "manage", "none", "manage-collectors", or "view-collectors".
Default value is "none".

```yaml
Type: String
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatePrivateDashboards
Indicates whether the role can create private dashboards.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowWidgetSharing
Indicates whether the role can share widgets.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigTabRequiresManagePermission
Indicates whether the role requires manage permission for the Config tab.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedToViewMapsTab
Indicates whether the role can view the Maps tab.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedToManageResourceDashboards
Indicates whether the role can manage resource dashboards.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewTraces
Indicates whether the role can view traces.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewSupport
Indicates whether the role can view support.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -EnableRemoteSessionForResources
Indicates whether the role can enable remote session for resources.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomPrivilegesObject
Specifies a custom privileges object for the role.

```yaml
Type: PSObject
Parameter Sets: Custom
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
