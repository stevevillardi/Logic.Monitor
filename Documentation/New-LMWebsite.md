---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMWebsite

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

```
New-LMWebsite [-Name] <String> [[-IsInternal] <Boolean>] [[-Description] <String>]
 [[-DisableAlerting] <Boolean>] [[-StopMonitoring] <Boolean>] [[-UseDefaultAlertSetting] <Boolean>]
 [[-UseDefaultLocationSetting] <Boolean>] [[-TriggerSSLStatusAlert] <Boolean>]
 [[-TriggerSSLExpirationAlert] <Boolean>] [[-GroupId] <String>] [-Hostname] <String> [[-HttpType] <String>]
 [[-SSLAlertThresholds] <String[]>] [[-PingCount] <Int32>] [[-PingTimeout] <Int32>]
 [[-PageLoadAlertTimeInMS] <Int32>] [[-PingPercentNotReceived] <Int32>] [[-FailedCount] <Int32>]
 [[-OverallAlertLevel] <String>] [[-IndividualAlertLevel] <String>] [[-Properties] <Hashtable>]
 [[-PropertiesMethod] <String>] [[-PollingInterval] <Int32>] [-Type] <String> [<CommonParameters>]
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
Position: 2
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
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FailedCount
{{ Fill FailedCount Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 60

Required: False
Position: 17
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GroupId
{{ Fill GroupId Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 9
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Hostname
{{ Fill Hostname Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HttpType
{{ Fill HttpType Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: http, https

Required: False
Position: 11
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IndividualAlertLevel
{{ Fill IndividualAlertLevel Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: warn, error, critical

Required: False
Position: 19
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -IsInternal
{{ Fill IsInternal Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
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
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverallAlertLevel
{{ Fill OverallAlertLevel Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: warn, error, critical

Required: False
Position: 18
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageLoadAlertTimeInMS
{{ Fill PageLoadAlertTimeInMS Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingCount
{{ Fill PingCount Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 5, 10, 15, 20, 30, 60

Required: False
Position: 13
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingPercentNotReceived
{{ Fill PingPercentNotReceived Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 10, 20, 30, 40, 50, 60, 70, 80, 90, 100

Required: False
Position: 16
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingTimeout
{{ Fill PingTimeout Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PollingInterval
{{ Fill PollingInterval Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10

Required: False
Position: 22
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
Position: 20
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
Position: 21
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSLAlertThresholds
{{ Fill SSLAlertThresholds Description }}

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
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
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLExpirationAlert
{{ Fill TriggerSSLExpirationAlert Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLStatusAlert
{{ Fill TriggerSSLStatusAlert Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Type
{{ Fill Type Description }}

```yaml
Type: String
Parameter Sets: (All)
Aliases:
Accepted values: pingcheck, webcheck

Required: True
Position: 23
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaultAlertSetting
{{ Fill UseDefaultAlertSetting Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaultLocationSetting
{{ Fill UseDefaultLocationSetting Description }}

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
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
