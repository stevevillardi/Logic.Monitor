---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMDevice

## SYNOPSIS
Get device info from a connected LM portal

## SYNTAX

### All (Default)
```
Get-LMDevice [-Delta] [-BatchSize <Int32>] [<CommonParameters>]
```

### Id
```
Get-LMDevice [-Id <Int32>] [-Delta] [-BatchSize <Int32>] [<CommonParameters>]
```

### DisplayName
```
Get-LMDevice [-DisplayName <String>] [-Delta] [-BatchSize <Int32>] [<CommonParameters>]
```

### Name
```
Get-LMDevice [-Name <String>] [-Delta] [-BatchSize <Int32>] [<CommonParameters>]
```

### Filter
```
Get-LMDevice [-Filter <Object>] [-Delta] [-BatchSize <Int32>] [<CommonParameters>]
```

### Delta
```
Get-LMDevice [-DeltaId <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get device info from a connected LM portal

## EXAMPLES

### EXAMPLE 1
```
Get all devices:
    Get-LMDevice
```

Get specific device:
    Get-LMDevice -Id 1
    Get-LMDevice -DisplayName "device.example.com"
    Get-LMDevice -Name "10.10.10.10"

Get multiple devices using wildcards:
    Get-LMDevice -DisplayName "*.example.com"
    Get-LMDevice -Name "10.10.*"

Get device/s using a custom filter:
    Get-LMDevice -Filter @{displayName="corp-*";preferredCollectorId=1}

## PARAMETERS

### -Id
The device id for a device in LM.

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

### -DisplayName
The display name value for a device in LM.
This value can include wildcard input such as "*.example.com"

```yaml
Type: String
Parameter Sets: DisplayName
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name value for a device in LM.
This is the fqdn/ip used when adding a device into LM.
This value accepts wildcard input such as "10.10.*"

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

An example Filter to get devices with alerting enabled and where the display name contains equal.com:
    @{displayName="*.example.com";disableAlerting=$false}

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

### -Delta
Switch used to return a deltaId along with the requested data to use for delta change tracking.

```yaml
Type: SwitchParameter
Parameter Sets: All, Id, DisplayName, Name, Filter
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DeltaId
The deltaId string for a delta query you want to see changes for.

```yaml
Type: String
Parameter Sets: Delta
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
