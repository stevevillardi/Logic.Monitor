---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMWebsiteGroup

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Id-ParentGroupId (Default)
```
Set-LMWebsiteGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-ParentGroupId <Int32>]
 [<CommonParameters>]
```

### Id-ParentGroupName
```
Set-LMWebsiteGroup -Id <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>]
 [-ParentGroupName <String>] [<CommonParameters>]
```

### Name-ParentGroupName
```
Set-LMWebsiteGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>]
 [-ParentGroupName <String>] [<CommonParameters>]
```

### Name-ParentGroupId
```
Set-LMWebsiteGroup -Name <String> [-NewName <String>] [-Description <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-ParentGroupId <Int32>]
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

### -DisableAlerting
{{ Fill DisableAlerting Description }}

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

### -Id
{{ Fill Id Description }}

```yaml
Type: String
Parameter Sets: Id-ParentGroupId, Id-ParentGroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -Name
{{ Fill Name Description }}

```yaml
Type: String
Parameter Sets: Name-ParentGroupName, Name-ParentGroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NewName
{{ Fill NewName Description }}

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
{{ Fill ParentGroupId Description }}

```yaml
Type: Int32
Parameter Sets: Id-ParentGroupId, Name-ParentGroupId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
{{ Fill ParentGroupName Description }}

```yaml
Type: String
Parameter Sets: Id-ParentGroupName, Name-ParentGroupName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Properties
{{ Fill Properties Description }}

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

### -PropertiesMethod
{{ Fill PropertiesMethod Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: Add, Replace, Refresh

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -StopMonitoring
{{ Fill StopMonitoring Description }}

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.String
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
