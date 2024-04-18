---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMCollectorInstaller

## SYNOPSIS
Downloads the LogicMonitor Collector installer based on the specified parameters.

## SYNTAX

### Id (Default)
```
Get-LMCollectorInstaller -Id <Int32> [-Size <String>] [-OSandArch <String>] [-UseEA <Boolean>]
 [-DownloadPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

### Name
```
Get-LMCollectorInstaller -Name <String> [-Size <String>] [-OSandArch <String>] [-UseEA <Boolean>]
 [-DownloadPath <String>] [-ProgressAction <ActionPreference>] [<CommonParameters>]
```

## DESCRIPTION
The Get-LMCollectorInstaller function downloads the LogicMonitor Collector installer based on the specified parameters.
It requires a valid API authentication and can be used to download the installer for a specific collector by its ID or name.
The function supports different operating systems and architectures, as well as collector sizes.

## EXAMPLES

### EXAMPLE 1
```
Get-LMCollectorInstaller -Id 1234 -Size medium -OSandArch Win64 -DownloadPath "C:\Downloads"
```

Downloads the LogicMonitor Collector installer for the collector with ID 1234, using the 'medium' size and 'Win64' operating system and architecture.
The installer file will be saved in the "C:\Downloads" directory.

### EXAMPLE 2
```
Get-LMCollectorInstaller -Name "MyCollector" -Size large -OSandArch Linux64
```

Downloads the LogicMonitor Collector installer for the collector with the name "MyCollector", using the 'large' size and 'Linux64' operating system and architecture.
The installer file will be saved in the current location.

## PARAMETERS

### -Id
The ID of the collector for which to download the installer.
This parameter is mandatory when using the 'Id' parameter set.

```yaml
Type: Int32
Parameter Sets: Id
Aliases:

Required: True
Position: Named
Default value: 0
Accept pipeline input: False
Accept wildcard characters: False
```

### -Name
The name of the collector for which to download the installer.
This parameter is mandatory when using the 'Name' parameter set.

```yaml
Type: String
Parameter Sets: Name
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Size
The size of the collector.
Valid values are 'nano', 'small', 'medium', 'large', 'extra_large', and 'double_extra_large'.
The default value is 'medium'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Medium
Accept pipeline input: False
Accept wildcard characters: False
```

### -OSandArch
The operating system and architecture of the collector.
Valid values are 'Win64' and 'Linux64'.
The default value is 'Win64'.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: Win64
Accept pipeline input: False
Accept wildcard characters: False
```

### -UseEA
Specifies whether to use the Early Access (EA) version of the collector.
By default, this parameter is set to $false.

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

### -DownloadPath
The path where the downloaded installer file will be saved.
By default, it is set to the current location.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: (Get-Location).Path
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
