---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Connect-LMAccount

## SYNOPSIS
Connect to a specified LM portal to run commands against

## SYNTAX

### LMv1 (Default)
```
Connect-LMAccount -AccessId <String> -AccessKey <String> -AccountName <String> [-AutoUpdateModuleVersion]
 [-DisableConsoleLogging] [-SkipVersionCheck] [-SkipCredValidation] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Bearer
```
Connect-LMAccount -BearerToken <String> -AccountName <String> [-AutoUpdateModuleVersion]
 [-DisableConsoleLogging] [-SkipVersionCheck] [-SkipCredValidation] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### SessionSync
```
Connect-LMAccount -AccountName <String> [-SessionSync] [-AutoUpdateModuleVersion] [-DisableConsoleLogging]
 [-SkipVersionCheck] [-SkipCredValidation] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Cached
```
Connect-LMAccount [-UseCachedCredential] [-CachedAccountName <String>] [-AutoUpdateModuleVersion]
 [-DisableConsoleLogging] [-SkipVersionCheck] [-SkipCredValidation] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands associated with the Logic.Monitor PS module.
Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

## EXAMPLES

### EXAMPLE 1
```
Connect-LMAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain
```

### EXAMPLE 2
```
Connect-LMAccount -BearerToken xxxxxx -AccountName subdomain
```

### EXAMPLE 3
```
Connect-LMAccount -UseCachedCredential
```

## PARAMETERS

### -AccessId
Access ID from your API credential acquired from the LM Portal

```yaml
Type: String
Parameter Sets: LMv1
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccessKey
Access Key from your API credential acquired from the LM Portal

```yaml
Type: String
Parameter Sets: LMv1
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -BearerToken
Bearer token from your API credential acquired from the LM Portal.
For use in place of LMv1 token

```yaml
Type: String
Parameter Sets: Bearer
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

```yaml
Type: String
Parameter Sets: LMv1, Bearer, SessionSync
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseCachedCredential
This will list all cached account for you to pick from.
This parameter is optional

```yaml
Type: SwitchParameter
Parameter Sets: Cached
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -CachedAccountName
Name of cached account you wish to connect to.
This parameter is optional and can be used in place of UseCachedCredential

```yaml
Type: String
Parameter Sets: Cached
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SessionSync
Use session sync capability instead of api key

```yaml
Type: SwitchParameter
Parameter Sets: SessionSync
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -AutoUpdateModuleVersion
{{ Fill AutoUpdateModuleVersion Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -DisableConsoleLogging
Disables on stdout messages from displaying for any subsequent commands are run.
Useful when building scripted logicmodules and you want to suppress unwanted output.
Console logging is enabled by default.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipVersionCheck
{{ Fill SkipVersionCheck Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipCredValidation
{{ Fill SkipCredValidation Description }}

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
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

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

## RELATED LINKS

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

