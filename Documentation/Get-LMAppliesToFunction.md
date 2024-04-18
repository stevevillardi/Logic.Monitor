---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version: https://www.logicmonitor.com/support/rest-api-developers-guide/
schema: 2.0.0
---

# Get-LMAppliesToFunction

## SYNOPSIS
Retrieves LogicMonitor AppliesTo functions based on different parameters.

## SYNTAX

### All (Default)
```
Get-LMAppliesToFunction [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Id
```
Get-LMAppliesToFunction [-Id <Int32>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Name
```
Get-LMAppliesToFunction [-Name <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMAppliesToFunction [-Filter <Object>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAppliesToFunction function retrieves LogicMonitor AppliesTo functions based on different parameters such as Id, Name, or Filter.
It uses the LogicMonitor API to make the requests and returns the results.

## EXAMPLES

### EXAMPLE 1
```
Get-LMAppliesToFunction -Id 123
Retrieves the AppliesTo function with the specified Id.
```

### EXAMPLE 2
```
Get-LMAppliesToFunction -Name "MyFunction"
Retrieves the AppliesTo function with the specified Name.
```

### EXAMPLE 3
```
Get-LMAppliesToFunction -Filter @{ Property = "Value" }
Retrieves the AppliesTo functions that match the specified custom filter.
```

## PARAMETERS

### -Id
Specifies the Id of the AppliesTo function to retrieve.
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
Specifies the Name of the AppliesTo function to retrieve.
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
Specifies a custom filter to apply when retrieving AppliesTo functions.
This parameter is mutually exclusive with the Id and Name parameters.
The filter should be an object that matches the filter structure expected by the LogicMonitor API.

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
Specifies the number of results to retrieve per request.
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
Make sure to log in using the Connect-LMAccount function before running any commands.

## RELATED LINKS

[https://www.logicmonitor.com/support/rest-api-developers-guide/](https://www.logicmonitor.com/support/rest-api-developers-guide/)

