---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMWebsite

## SYNOPSIS
Creates a new LogicMonitor website or ping check.

## SYNTAX

### Website
```
New-LMWebsite [-WebCheck] -Name <String> [-IsInternal <Boolean>] [-Description <String>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-UseDefaultAlertSetting <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-TriggerSSLStatusAlert <Boolean>]
 [-TriggerSSLExpirationAlert <Boolean>] [-GroupId <String>] -WebsiteDomain <String> [-HttpType <String>]
 [-SSLAlertThresholds <String[]>] [-PageLoadAlertTimeInMS <Int32>] [-IgnoreSSL <Boolean>]
 [-FailedCount <Int32>] [-OverallAlertLevel <String>] [-IndividualAlertLevel <String>]
 [-Properties <Hashtable>] [-PropertiesMethod <String>] [-PollingInterval <Int32>] [-WebsiteSteps <Object[]>]
 [-CheckPoints <Object[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Ping
```
New-LMWebsite [-PingCheck] -Name <String> [-IsInternal <Boolean>] [-Description <String>]
 [-DisableAlerting <Boolean>] [-StopMonitoring <Boolean>] [-UseDefaultAlertSetting <Boolean>]
 [-UseDefaultLocationSetting <Boolean>] [-GroupId <String>] -PingAddress <String> [-PingCount <Int32>]
 [-PingTimeout <Int32>] [-PingPercentNotReceived <Int32>] [-FailedCount <Int32>] [-OverallAlertLevel <String>]
 [-IndividualAlertLevel <String>] [-Properties <Hashtable>] [-PropertiesMethod <String>]
 [-PollingInterval <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMWebsite function is used to create a new LogicMonitor website or ping check.
It allows you to specify various parameters such as the type of check (website or ping), the name of the check, the description, and other settings related to monitoring and alerting.

## EXAMPLES

### EXAMPLE 1
```
New-LMWebsite -WebCheck -Name "Example Website" -WebsiteDomain "example.com" -HttpType "https" -GroupId "12345" -OverallAlertLevel "error" -IndividualAlertLevel "warn"
```

This example creates a new LogicMonitor website check for the website "example.com" with HTTPS protocol.
It assigns the check to the group with ID "12345" and sets the overall alert level to "error" and the individual alert level to "warn".

### EXAMPLE 2
```
New-LMWebsite -PingCheck -Name "Example Ping" -PingAddress "192.168.1.1" -PingCount 5 -PingTimeout 1000 -GroupId "12345" -OverallAlertLevel "warn" -IndividualAlertLevel "warn"
```

This example creates a new LogicMonitor ping check for the IP address "192.168.1.1".
It sends 5 pings with a timeout of 1000 milliseconds.
It assigns the check to the group with ID "12345" and sets the overall alert level and individual alert level to "warn".

## PARAMETERS

### -WebCheck
Specifies that the check type is a website check.
This parameter is mutually exclusive with the PingCheck parameter.

```yaml
Type: SwitchParameter
Parameter Sets: Website
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -PingCheck
Specifies that the check type is a ping check.
This parameter is mutually exclusive with the WebCheck parameter.

```yaml
Type: SwitchParameter
Parameter Sets: Ping
Aliases:

Required: True
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
Specifies the name of the check.

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

### -IsInternal
Specifies whether the check is internal or external.
By default, it is set to $false.

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

### -Description
Specifies the description of the check.

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
Specifies whether alerting is disabled for the check.

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

### -StopMonitoring
Specifies whether monitoring is stopped for the check.

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

### -UseDefaultAlertSetting
Specifies whether to use the default alert settings for the check.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseDefaultLocationSetting
Specifies whether to use the default location settings for the check.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -TriggerSSLStatusAlert
Specifies whether to trigger an alert when the SSL status of the website check changes.

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

### -TriggerSSLExpirationAlert
Specifies whether to trigger an alert when the SSL certificate of the website check is about to expire.

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

### -GroupId
Specifies the ID of the group to which the check belongs.

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

### -PingAddress
Specifies the address to ping for the ping check.

```yaml
Type: String
Parameter Sets: Ping
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteDomain
Specifies the domain of the website to check.

```yaml
Type: String
Parameter Sets: Website
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -HttpType
Specifies the HTTP type to use for the website check.
The valid values are "http" and "https".
The default value is "https".

```yaml
Type: String
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: Https
Accept pipeline input: False
Accept wildcard characters: False
```

### -SSLAlertThresholds
Specifies the SSL alert thresholds for the website check.

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

### -PingCount
Specifies the number of pings to send for the ping check.
The valid values are 5, 10, 15, 20, 30, and 60.

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

### -PingTimeout
Specifies the timeout for the ping check.

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

### -PageLoadAlertTimeInMS
Specifies the page load alert time in milliseconds for the website check.

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

### -IgnoreSSL
Specifies whether to ignore SSL errors for the website check.

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

### -PingPercentNotReceived
Specifies the percentage of packets not received in time for the ping check.
The valid values are 10, 20, 30, 40, 50, 60, 70, 80, 90, and 100.

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

### -FailedCount
Specifies the number of consecutive failed checks required to trigger an alert.
The valid values are 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, and 60.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -OverallAlertLevel
Specifies the overall alert level for the check.
The valid values are "warn", "error", and "critical".

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

### -IndividualAlertLevel
Specifies the individual alert level for the check.
The valid values are "warn", "error", and "critical".

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
Specifies additional custom properties for the check.

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
Specifies the method to use for handling custom properties.
The valid values are "Add", "Replace", and "Refresh".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Replace
Accept pipeline input: False
Accept wildcard characters: False
```

### -PollingInterval
Specifies the polling interval for the check.

```yaml
Type: Int32
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WebsiteSteps
Specifies the steps to perform for the website check.

```yaml
Type: Object[]
Parameter Sets: Website
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CheckPoints
Specifies the check points for the check.

```yaml
Type: Object[]
Parameter Sets: Website
Aliases:

Required: False
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
