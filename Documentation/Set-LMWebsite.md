---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Set-LMWebsite

## SYNOPSIS
{{ Fill in the Synopsis }}

## SYNTAX

### Website (Default)
```
Set-LMWebsite -Id <String> [-Name <String>] [-IsInternal <Boolean>] [-Description <String>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-UseDefaultAlertSetting <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-TriggerSSLStatusAlert <Boolean>]
 [-TriggerSSLExpirationAlert <Boolean>] [-GroupId <String>] [-WebsiteDomain <String>] [-HttpType <String>]
 [-SSLAlertThresholds <String[]>] [-PageLoadAlertTimeInMS <Int32>] [-FailedCount <Int32>]
 [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>] [-Properties <Hashtable>]
 [-PropertiesMethod <String>] [-PollingInterval <Int32>] [-WebsiteSteps <String[]>] [<CommonParameters>]
```

### Ping
```
Set-LMWebsite -Id <String> [-Name <String>] [-IsInternal <Boolean>] [-Description <String>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-UseDefaultAlertSetting <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-GroupId <String>] [-PingAddress <String>] [-PingCount <Int32>]
 [-PingTimeout <Int32>] [-PingPercentNotReceived <Int32>] [-FailedCount <Int32>] [-OverallAlertLevel <String>]
 [-IndividualAlertLevel <String>] [-Properties <Hashtable>] [-PropertiesMethod <String>]
 [-PollingInterval <Int32>] [<CommonParameters>]
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

### -FailedCount
{{ Fill FailedCount Description }}

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:
Accepted values: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 60

Required: False
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HttpType
{{ Fill HttpType Description }}

```yaml
Type: String
Parameter Sets: Website
Aliases:
Accepted values: http, https

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
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: True (ByPropertyName)
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
Position: Named
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

Required: False
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PageLoadAlertTimeInMS
{{ Fill PageLoadAlertTimeInMS Description }}

```yaml
Type: Int32
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingAddress
{{ Fill PingAddress Description }}

```yaml
Type: String
Parameter Sets: Ping
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingCount
{{ Fill PingCount Description }}

```yaml
Type: Int32
Parameter Sets: Ping
Aliases:
Accepted values: 5, 10, 15, 20, 30, 60

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingPercentNotReceived
{{ Fill PingPercentNotReceived Description }}

```yaml
Type: Int32
Parameter Sets: Ping
Aliases:
Accepted values: 10, 20, 30, 40, 50, 60, 70, 80, 90, 100

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingTimeout
{{ Fill PingTimeout Description }}

```yaml
Type: Int32
Parameter Sets: Ping
Aliases:

Required: False
Position: Named
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

### -SSLAlertThresholds
{{ Fill SSLAlertThresholds Description }}

```yaml
Type: String[]
Parameter Sets: Website
Aliases:

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

### -TriggerSSLExpirationAlert
{{ Fill TriggerSSLExpirationAlert Description }}

```yaml
Type: Boolean
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLStatusAlert
{{ Fill TriggerSSLStatusAlert Description }}

```yaml
Type: Boolean
Parameter Sets: Website
Aliases:

Required: False
Position: Named
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
Position: Named
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
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteDomain
{{ Fill WebsiteDomain Description }}

```yaml
Type: String
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteSteps
{{ Fill WebsiteSteps Description }}

```yaml
Type: String[]
Parameter Sets: Website
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

### None
## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
