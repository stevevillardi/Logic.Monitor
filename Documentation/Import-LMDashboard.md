---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Import-LMDashboard

## SYNOPSIS
Imports LogicMonitor dashboards from various sources.

## SYNTAX

### FilePath-GroupName
```
Import-LMDashboard -FilePath <String> -ParentGroupName <String> [-ReplaceAPITokensOnImport]
 [-APIToken <Object>] [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### FilePath-GroupId
```
Import-LMDashboard -FilePath <String> -ParentGroupId <String> [-ReplaceAPITokensOnImport] [-APIToken <Object>]
 [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### File-GroupName
```
Import-LMDashboard -File <String> -ParentGroupName <String> [-ReplaceAPITokensOnImport] [-APIToken <Object>]
 [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### File-GroupId
```
Import-LMDashboard -File <String> -ParentGroupId <String> [-ReplaceAPITokensOnImport] [-APIToken <Object>]
 [-PrivateUserName <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Repo-GroupName
```
Import-LMDashboard -GithubUserRepo <String> [-GithubAccessToken <String>] -ParentGroupName <String>
 [-ReplaceAPITokensOnImport] [-APIToken <Object>] [-PrivateUserName <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Repo-GroupId
```
Import-LMDashboard -GithubUserRepo <String> [-GithubAccessToken <String>] -ParentGroupId <String>
 [-ReplaceAPITokensOnImport] [-APIToken <Object>] [-PrivateUserName <String>]
 [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The \`Import-LMDashboard\` function allows you to import LogicMonitor dashboards from different sources, such as local files, GitHub repositories, or LogicMonitor dashboard groups.
It supports importing dashboards in JSON format.

## EXAMPLES

### EXAMPLE 1
```
Import-LMDashboard -FilePath "C:\Dashboards" -ParentGroupId 12345 -ReplaceAPITokensOnImport -APIToken $apiToken
Imports all JSON dashboard files from the "C:\Dashboards" directory and its subdirectories. The imported dashboards will be placed under the dashboard group with ID 12345. API tokens in the imported dashboards will be replaced with the specified API token.
```

### EXAMPLE 2
```
Import-LMDashboard -GithubUserRepo "username/repo" -ParentGroupName "MyDashboards" -ReplaceAPITokensOnImport -APIToken $apiToken
Imports JSON dashboard files from the specified GitHub repository. The imported dashboards will be placed under the dashboard group with the name "MyDashboards". API tokens in the imported dashboards will be replaced with the specified API token.
```

## PARAMETERS

### -FilePath
Specifies the path to a local file or directory containing the JSON dashboard files to import.
If a directory is specified, all JSON files within the directory (and its subdirectories) will be imported.

```yaml
Type: String
Parameter Sets: FilePath-GroupName, FilePath-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -File
Specifies a single JSON dashboard file to import.

```yaml
Type: String
Parameter Sets: File-GroupName, File-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GithubUserRepo
Specifies the GitHub repository (in the format "username/repo") from which to import JSON dashboard files.

```yaml
Type: String
Parameter Sets: Repo-GroupName, Repo-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GithubAccessToken
Specifies the GitHub access token to use for authenticated requests.
This is required for large repositories, as the GitHub API has rate limits for unauthenticated requests.

```yaml
Type: String
Parameter Sets: Repo-GroupName, Repo-GroupId
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupId
Specifies the ID of the parent dashboard group under which the imported dashboards will be placed.
This parameter is mandatory when importing from a file or GitHub repository.

```yaml
Type: String
Parameter Sets: FilePath-GroupId, File-GroupId, Repo-GroupId
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ParentGroupName
Specifies the name of the parent dashboard group under which the imported dashboards will be placed.
This parameter is mandatory when importing from a file or GitHub repository.

```yaml
Type: String
Parameter Sets: FilePath-GroupName, File-GroupName, Repo-GroupName
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ReplaceAPITokensOnImport
Indicates whether to replace API tokens in the imported dashboards with a dynamically generated API token.
This is useful for managing API access to the dashboards.

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

### -APIToken
Specifies the API token to use for replacing API tokens in the imported dashboards.
This parameter is required when \`ReplaceAPITokensOnImport\` is set to \`$true\`.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -PrivateUserName
Specifies the username of dashboard owner when creating dashboard as private.

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
