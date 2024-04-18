---
external help file: Logic.Monitor-help.xml
Module Name: Logic.Monitor
online version:
schema: 2.0.0
---

# Get-LMAccountStatus

## SYNOPSIS
Retrieves the status of the LogicMonitor account.

## SYNTAX

```
Get-LMAccountStatus [<CommonParameters>]
```

## DESCRIPTION
The Get-LMAccountStatus function is used to retrieve the status of the LogicMonitor account.
It checks if the user is currently logged into any LogicMonitor portals and returns the account status.

## EXAMPLES

### EXAMPLE 1
```
Get-LMAccountStatus
```

This example demonstrates how to use the Get-LMAccountStatus function to retrieve the status of the LogicMonitor account.

## PARAMETERS

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

## OUTPUTS

### [System.Management.Automation.PSCustomObject]
### The function returns a custom object with the following properties:
### - Portal: The LogicMonitor portal URL.
### - Valid: Indicates if the user is currently logged into a LogicMonitor portal.
### - Logging: Indicates if logging is enabled for the LogicMonitor account.
### - Type: The type of authentication used for the LogicMonitor account.
## NOTES

## RELATED LINKS
