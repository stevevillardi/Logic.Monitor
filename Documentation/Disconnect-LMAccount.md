---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Disconnect-LMAccount

## SYNOPSIS
Disconnect from a previouslly connected LM portal

## SYNTAX

```
Disconnect-LMAccount [<CommonParameters>]
```

## DESCRIPTION
Clears stored API credentials for a previously connected LM portal.
Useful for switching between LM portals or clearing credentials after a script runs

## EXAMPLES

### EXAMPLE 1
```
Disconnect-LMAccount
```

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### None. You cannot pipe objects to this command.
## OUTPUTS

## NOTES
Once disconnect you will need to reconnect to a portal before you will be allowed to run commands again.

## RELATED LINKS

[Module repo: https://github.com/stevevillardi/Logic.Monitor]()

[PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor]()

