---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMWebsiteGroup

## SYNOPSIS
Creates a new LogicMonitor website group.

## SYNTAX

### GroupId
```
New-LMWebsiteGroup -Name <String> [-Description <String>] [-Properties <Hashtable>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] -ParentGroupId <Int32>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### GroupName
```
New-LMWebsiteGroup -Name <String> [-Description <String>] [-Properties <Hashtable>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] -ParentGroupName <String>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMWebsiteGroup function creates a new website group in LogicMonitor.
It allows you to specify the name, description, properties, and parent group of the website group.

## EXAMPLES

### EXAMPLE 1
```
New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupId 1234
```

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group ID 1234.

### EXAMPLE 2
```
New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupName "ParentGroup"
```

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group name "ParentGroup".

## PARAMETERS

### -Name
The name of the website group.
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
The description of the website group.

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
A hashtable of custom properties for the website group.

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

### -DisableAlerting
Specifies whether to disable alerting for the website group.
By default, alerting is enabled.

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

### -StopMonitoring
Specifies whether to stop monitoring the website group.
By default, monitoring is not stopped.

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

### -ParentGroupId
The ID of the parent group.
This parameter is mandatory if the ParentGroupName parameter is not specified.

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
This parameter is mandatory if the ParentGroupId parameter is not specified.

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

## RELATED LINKS
