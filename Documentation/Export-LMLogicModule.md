---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Export-LMLogicModule

## SYNOPSIS
Exports a specified logicmodule

## SYNTAX

### Id (Default)
```
Export-LMLogicModule -LogicModuleId <Int32> -Type <String> [-DownloadPath <String>] [<CommonParameters>]
```

### Name
```
Export-LMLogicModule -LogicModuleName <String> -Type <String> [-DownloadPath <String>] [<CommonParameters>]
```

## DESCRIPTION
Exports logic module for backup/import into another portal

## EXAMPLES

### EXAMPLE 1
```
Export-LMLogicModule -LogicModuleId 1907 -Type "eventsources"
```

### EXAMPLE 2
```
Export-LMLogicModule -LogicModuleName "SNMP_Network_Interfaces" -Type "datasources"
```

## PARAMETERS

### -LogicModuleId
Id of the logic module you are looking to export

```yaml
Type: Int32
Parameter Sets: Id
Aliases: Id

Required: True
Position: Named
Default value: 0
Accept pipeline input: True (ByPropertyName)
Accept wildcard characters: False
```

### -LogicModuleName
Name of the logic module you are looking to export, used as an alternative to LogicModuleId

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

### -Type
Type of logic module to export

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

### -DownloadPath
Path to export the logic module to, defaults to current directory if not specified

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

