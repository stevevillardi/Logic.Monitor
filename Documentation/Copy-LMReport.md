---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Copy-LMReport

## SYNOPSIS
Copies a LogicMonitor report.

## SYNTAX

```
Copy-LMReport [-Name] <String> [[-Description] <String>] [[-ParentGroupId] <String>] [-ReportObject] <Object>
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Copy-LMReport function is used to copy a LogicMonitor report.
It takes the following parameters:
- Name: The name of the report.
- Description: The description of the report.
- ParentGroupId: The ID of the parent group.
- ReportObject: The report object to be copied.

## EXAMPLES

### EXAMPLE 1
```
Copy-LMReport -Name "Report1" -Description "This is a sample report" -ParentGroupId "12345" -ReportObject $reportObject
```

This example copies the report specified by the ReportObject parameter and sets the name, description, and parent group ID.

## PARAMETERS

### -Name
The name of the report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Description
The description of the report.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
The ID of the parent group.

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

### -ReportObject
The report object to be copied.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 4
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
Please ensure you are logged in before running any commands.
Use Connect-LMAccount to login and try again.

## RELATED LINKS
