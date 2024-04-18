---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAPIToken

## SYNOPSIS
Retrieves LogicMonitor API tokens based on specified parameters.

## SYNTAX

### All (Default)
```
Get-LMAPIToken [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### AdminId
```
Get-LMAPIToken [-AdminId <Int32>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Id
```
Get-LMAPIToken [-Id <Int32>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### AccessId
```
Get-LMAPIToken [-AccessId <String>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

### Filter
```
Get-LMAPIToken [-Filter <Object>] [-Type <String>] [-BatchSize <Int32>] [-ProgressAction <ActionPreference>]
 [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAPIToken function retrieves LogicMonitor API tokens based on the specified parameters.
It supports various parameter sets to filter the tokens based on different criteria such as AdminId, Id, AccessId, and Filter.
The function also allows specifying the token type and batch size for pagination.

## EXAMPLES

### EXAMPLE 1
```
Get-LMAPIToken -AdminId 1234
Retrieves all API tokens associated with the admin ID 1234.
```

### EXAMPLE 2
```
Get-LMAPIToken -Id 5678
Retrieves the API token with the ID 5678.
```

### EXAMPLE 3
```
Get-LMAPIToken -AccessId "abc123"
Retrieves the API token with the access ID "abc123".
```

### EXAMPLE 4
```
Get-LMAPIToken -Filter @{ Property1 = "Value1"; Property2 = "Value2" }
Retrieves API tokens based on the specified custom filter object.
```

### EXAMPLE 5
```
Get-LMAPIToken -Type "Bearer" -BatchSize 500
Retrieves API tokens of type 'Bearer' with a batch size of 500.
```

## PARAMETERS

### -AdminId
Specifies the ID of the admin for which to retrieve API tokens.
This parameter is only applicable when using the 'AdminId' parameter set.

```yaml
Type: Int32
Parameter Sets: AdminId
Aliases:

Required: False
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Id
Specifies the ID of the API token to retrieve.
This parameter is only applicable when using the 'Id' parameter set.

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

### -AccessId
Specifies the access ID of the API token to retrieve.
This parameter is only applicable when using the 'AccessId' parameter set.

```yaml
Type: String
Parameter Sets: AccessId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Filter
Specifies a custom filter object to retrieve API tokens based on specific criteria.
This parameter is only applicable when using the 'Filter' parameter set.

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

### -Type
Specifies the type of API token to retrieve.
Valid values are 'LMv1', 'Bearer', or '*'.
The default value is '*'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: *
Accept pipeline input: False
Accept wildcard characters: False
```

### -BatchSize
Specifies the number of API tokens to retrieve per batch.
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
This function requires a valid LogicMonitor authentication session.
Make sure to log in using the Connect-LMAccount function before running this command.

## RELATED LINKS
