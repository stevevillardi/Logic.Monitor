---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMWebsite

## SYNOPSIS
Get website info from a connected LM portal

## SYNTAX

### All (Default)
```
Get-LMWebsite [-BatchSize <Int32>] [<CommonParameters>]
```

### Id
```
Get-LMWebsite [-Id <Int32>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Name
```
Get-LMWebsite [-Name <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Type
```
Get-LMWebsite [-Type <String>] [-BatchSize <Int32>] [<CommonParameters>]
```

### Filter
```
Get-LMWebsite [-Filter <Object>] [-BatchSize <Int32>] [<CommonParameters>]
```

## DESCRIPTION
Get website info from a connected LM portal

## EXAMPLES

### EXAMPLE 1
```
Get all websites:
    Get-LMWebsite
```

Get specific website:
    Get-LMWebsite -Id 1
    Get-LMWebsite -Name "LogicMonitor"

Get multiple websites using wildcards:
    Get-LMWebsite -Name "ServiceNow - *"

Get websites using a custom filter:
    Get-LMWebsite -Filter @{type="webcheck";isInternal=$true}

## PARAMETERS

### -Id
The website id for a website in LM.

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
The name value for a website in LM.
This value accepts wildcard input such as "ServiceNow - *"

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

### -Type
The type of websites to return.
Possible values are: Webcheck or PingCheck

```yaml
Type: String
Parameter Sets: Type
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

An example Filter to get websites with type Webcheck that are internal:
    @{type="webcheck";isInternal=$true}

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
