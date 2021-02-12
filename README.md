# General
Windows PowerShell module for accessing the LogicMonitor REST API, using v3 and v4 endpoints.

This project is also published in the PowerShell Gallery at https://www.powershellgallery.com/packages/Logic.Monitor/.

# Installation
- From PowerShell Gallery: Install-Module -Name **Logic.Monitor**

# Change List
## 3.0.5.1
- Updated Get-LMAlert and Get-LMAuditLogs to work with large number of record returns
- Switched out Invoke-WebRequest for Invoke-RestMethod on all commandlets
- Added **Get-LMWebsiteData** command
- Added helper functions for type casting return objects as ground work for accepting pipeline input and controling default display output
## 3.0.4.1
- Updated Commands to accept pipeline object (Get-LMx | Set-LMx)
  - Updated **(Remove|Get|Set)-LMDevice**
  - Updated **(Remove|Get|Set)-LMDeviceGroup**
  - Updated **(Remove|Get|Set)-LMUser**
## 3.0.3.1
- Added New Commands
  - Added **Remove-LMDevice**
  - Added **Remove-LMDashboard**
  - Added **Remove-LMDashboardWidget**
  - Added **Remove-LMDatasource**
  - Added **Remove-LMWebsite**
  - Added **Set-LMDevice**
  - Added **Set-LMWebsite**
## 3.0.2.1
- Added New Commands
  - Added **Remove-LMAPIToken**
  - Added **Set-LMAPIToken**
  - Added **New-LMDeviceGroup**
  - Added **Remove-LMDeviceGroup**
  - Added **Set-LMDeviceGroup**
## 3.0.1.1
- Get-LM* Modules
  - Changed the filter parameter in applicable Get-LM* commands to use a hashtable, also added a PropsList array and helper function for URL encoding the filter. Filters can now be formated as such: **-Filter @{name="Steve*";staus="active"}**
## 3.0.1.0
- Added New LMUser Commands
  - Added **New-LMUser**
  - Added **New-LMAPIToken**
  - Added **Set-LMUser**
  - Added **Remove-LMUser**
  - Improved error handling for Http exceptions and added helper function to parse LM API v4 response errors.
