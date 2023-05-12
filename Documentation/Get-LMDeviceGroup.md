---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDeviceGroup

## SYNOPSIS
Get device group info from a connected LM portal

## SYNTAX

### All (Default)
```
Get-LMDeviceGroup [-BatchSize <Int32>] [<CommonParameters>]
```

### Id
```
Get-LMDeviceGroup [-Id <Int32>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Name
```
Get-LMDeviceGroup [-Name <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Filter
```
Get-LMDeviceGroup [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get device group info from a connected LM portal

## EXAMPLES

### EXAMPLE 1
```
Get all device groups:
    Get-LMDeviceGroup
```

Get specific device group:
    Get-LMDeviceGroup -Id 1
    Get-LMDeviceGroup -Name "Locations"

Get multiple device groups using wildcards:
    Get-LMDeviceGroup -Name "* - Servers"

Get device groups using a custom filter:
    Get-LMDeviceGroup -Filter @{parentId=1;disableAlerting=$false}

## PARAMETERS

### -Id
The device group id for a device group in LM.

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
The name value for a device group in LM.
This value accepts wildcard input such as "* - Servers"

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
A hashtable of additonal filter properties to include with request.
All properies are treated as if using the equals ":" operator.
When using multiple filters they are combined as AND conditions.

An example Filter to get devices with alerting enabled and where the parent groud id equals 1:
    @{parentId=1;disableAlerting=$false}

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
The return size for each request, this value if not specified defaults to 1000.
If a result would return 1001 and items, two requests would be made to return the full set.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

## NOTES
Consult the LM API docs for a list of allowed fields when using filter parameter as all fields are not available for use with filtering.

## RELATED LINKS
