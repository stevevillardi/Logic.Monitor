---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# New-LMUser

## SYNOPSIS
Creates a new LogicMonitor user.

## SYNTAX

```
New-LMUser [-Username] <String> [-Email] <String> [[-AcceptEULA] <Boolean>] [[-Password] <String>]
 [[-UserGroups] <String[]>] [[-FirstName] <String>] [[-LastName] <String>] [[-ForcePasswordChange] <Boolean>]
 [[-Phone] <String>] [[-Note] <String>] [[-RoleNames] <String[]>] [[-SmsEmail] <String>]
 [[-SmsEmailFormat] <String>] [[-Status] <String>] [[-Timezone] <String>] [[-TwoFAEnabled] <Boolean>]
 [[-Views] <String[]>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The New-LMUser function creates a new user in LogicMonitor with the specified parameters.

## EXAMPLES

### EXAMPLE 1
```
New-LMUser -Username "john.doe" -Email "john.doe@example.com" -Password "P@ssw0rd" -RoleNames @("admin") -Views @("Dashboards", "Reports")
```

This example creates a new LogicMonitor user with the username "john.doe", email "john.doe@example.com", password "P@ssw0rd", role "admin", and access to the "Dashboards" and "Reports" views.

## PARAMETERS

### -Username
The username of the new user.
This parameter is mandatory.

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

### -Email
The email address of the new user.
This parameter is mandatory.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: True
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AcceptEULA
Specifies whether the user has accepted the End User License Agreement (EULA).
The default value is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Password
The password for the new user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 4
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UserGroups
An array of user group names to which the new user should be added.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 5
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -FirstName
The first name of the new user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 6
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LastName
The last name of the new user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 7
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ForcePasswordChange
Specifies whether the new user should be forced to change their password on first login.
The default value is $true.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 8
Default value: True
Accept pipeline input: False
Accept wildcard characters: False
```

### -Phone
The phone number of the new user.

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

### -Note
A note or description for the new user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 10
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -RoleNames
An array of role names to assign to the new user.
The default value is "readonly".

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 11
Default value: @("readonly")
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmsEmail
The SMS email address for the new user.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 12
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SmsEmailFormat
The format of SMS emails for the new user.
Valid values are "sms" and "fulltext".
The default value is "sms".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 13
Default value: Sms
Accept pipeline input: False
Accept wildcard characters: False
```

### -Status
The status of the new user.
Valid values are "active" and "suspended".
The default value is "active".

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 14
Default value: Active
Accept pipeline input: False
Accept wildcard characters: False
```

### -Timezone
The timezone for the new user.
Valid values are listed in the function code.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 15
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TwoFAEnabled
Specifies whether two-factor authentication (2FA) is enabled for the new user.
The default value is $false.

```yaml
Type: Boolean
Parameter Sets: (All)
Aliases:

Required: False
Position: 16
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Views
An array of views that the new user should have access to.
Valid values are listed in the function code.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: 17
Default value: @("All")
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
This function requires valid API credentials and a logged-in session in LogicMonitor.

## RELATED LINKS
