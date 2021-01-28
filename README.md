# General
Windows PowerShell module for accessing the LogicMonitor REST API, using v3 and v4 endpoints.

This project is also published in the PowerShell Gallery at https://www.powershellgallery.com/packages/Logic.Monitor/.

# Installation
- From PowerShell Gallery: Install-Module -Name **Logic.Monitor**

# Change List
## 3.0.2.1
- Added New Commands
  - Added **Remove-LMAPIToken**
  - Added **Set-LMAPIToken**
## 3.0.1.1
- Get-LM* Modules
  - Changed the filter parameter in applicable Get-LM* commands to use a hashtable, also added a PropsList array and helper function for URL encoding the filter. Filters can now be formated as such: **-Filter @{name="Steve";staus="active"}**
## 3.0.1.0
- Added New LMUser Commands
  - Added **New-LMUser**
  - Added **New-LMAPIToken**
  - Added **Set-LMUser**
  - Added **Remove-LMUser**
  - Improved error handling for Http exceptions and added helper function to parse LM API v4 response errors.
