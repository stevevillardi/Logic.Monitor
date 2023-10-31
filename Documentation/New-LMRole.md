---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMRole

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Default (Default)
```
New-LMRole -Name <String> [-CustomHelpLabel <String>] [-CustomHelpURL <String>] [-Description <String>]
 [-RequireEULA] [-TwoFARequired <Boolean>] [-RoleGroupId <String>] [-DashboardsPermission <String>]
 [-ResourcePermission <String>] [-LogsPermission <String>] [-WebsitesPermission <String>]
 [-SavedMapsPermission <String>] [-ReportsPermission <String>] [-SettingsPermission <String>]
 [-CreatePrivateDashboards] [-AllowWidgetSharing] [-ConfigTabRequiresManagePermission] [-AllowedToViewMapsTab]
 [-AllowedToManageResourceDashboards] [-ViewTraces] [-ViewSupport] [-EnableRemoteSessionForResources]
 [<CommonParameters>]
```

### Custom
```
New-LMRole -Name <String> [-CustomHelpLabel <String>] [-CustomHelpURL <String>] [-Description <String>]
 [-RequireEULA] [-TwoFARequired <Boolean>] [-RoleGroupId <String>] -CustomPrivilegesObject <PSObject>
 [<CommonParameters>]
```

## DESCRIPTION
{{ Fill in the Description }}

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

## PARAMETERS

### -AllowWidgetSharing
{{ Fill AllowWidgetSharing Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedToManageResourceDashboards
{{ Fill AllowedToManageResourceDashboards Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AllowedToViewMapsTab
{{ Fill AllowedToViewMapsTab Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ConfigTabRequiresManagePermission
{{ Fill ConfigTabRequiresManagePermission Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CreatePrivateDashboards
{{ Fill CreatePrivateDashboards Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomHelpLabel
{{ Fill CustomHelpLabel Description }}

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
{{ Fill CustomHelpURL Description }}

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

### -CustomPrivilegesObject
{{ Fill CustomPrivilegesObject Description }}

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

### -DashboardsPermission
{{ Fill DashboardsPermission Description }}

```yaml
Type: String
Parameter Sets: Default
Aliases:
Accepted values: view, manage, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
{{ Fill Description Description }}

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

### -EnableRemoteSessionForResources
{{ Fill EnableRemoteSessionForResources Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LogsPermission
{{ Fill LogsPermission Description }}

```yaml
Type: String
Parameter Sets: Default
Aliases:
Accepted values: view, manage, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

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

### -ReportsPermission
{{ Fill ReportsPermission Description }}

```yaml
Type: String
Parameter Sets: Default
Aliases:
Accepted values: view, manage, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RequireEULA
{{ Fill RequireEULA Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ResourcePermission
{{ Fill ResourcePermission Description }}

```yaml
Type: String
Parameter Sets: Default
Aliases:
Accepted values: view, manage, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleGroupId
{{ Fill RoleGroupId Description }}

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

### -SavedMapsPermission
{{ Fill SavedMapsPermission Description }}

```yaml
Type: String
Parameter Sets: Default
Aliases:
Accepted values: view, manage, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SettingsPermission
{{ Fill SettingsPermission Description }}

```yaml
Type: String
Parameter Sets: Default
Aliases:
Accepted values: view, manage, none, manage-collectors, view-collectors

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TwoFARequired
{{ Fill TwoFARequired Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewSupport
{{ Fill ViewSupport Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ViewTraces
{{ Fill ViewTraces Description }}

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsitesPermission
{{ Fill WebsitesPermission Description }}

```yaml
Type: String
Parameter Sets: Default
Aliases:
Accepted values: view, manage, none

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
