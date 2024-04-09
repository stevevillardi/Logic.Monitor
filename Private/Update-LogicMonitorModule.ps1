<#
.SYNOPSIS
    Updates LogicMonitor modules to the latest version.

.DESCRIPTION
    The Update-LogicMonitorModule function is used to update LogicMonitor modules to the latest version. It checks the currently installed version of the module and compares it with the latest version available online. If a newer version is found, it uninstalls the old version and installs the newer version.

.PARAMETER Modules
    Specifies the LogicMonitor modules to update. By default, it updates both 'Logic.Monitor' and 'Logic.Monitor.SE' modules. You can provide an array of module names to update multiple modules.

.PARAMETER UninstallFirst
    Specifies whether to uninstall the old version before installing the newer version. By default, it is set to $False, which means the old version will not be uninstalled.

.PARAMETER CheckOnly
    Specifies whether to only check for updates without performing any installations. If this switch is used, it will display a message indicating the outdated version and suggest upgrading to the latest version.

.EXAMPLE
    Update-LogicMonitorModule -Modules @('Logic.Monitor')

    This example updates the 'Logic.Monitor' module to the latest version.

.EXAMPLE
    Update-LogicMonitorModule -UninstallFirst -Modules @('Logic.Monitor', 'Logic.Monitor.SE')

    This example uninstalls the old versions of 'Logic.Monitor' and 'Logic.Monitor.SE' modules before installing the latest versions.

.EXAMPLE
    Update-LogicMonitorModule -CheckOnly

    This example checks for updates of all installed LogicMonitor modules without performing any installations.

#>

Function Update-LogicMonitorModule {
    Param (
        [String[]]$Modules = @('Logic.Monitor','Logic.Monitor.SE'),
        [Boolean]$UninstallFirst = $False,
        [Switch]$CheckOnly
    )

    Foreach($Module in $Modules){
        # Read the currently installed version
        $Installed = Get-Module -ListAvailable -Name $Module
    
        # There might be multiple versions
        If ($Installed -is [Array]) {
            $InstalledVersion = $Installed[0].Version
        }
        ElseIf($Installed.Version) {
            $InstalledVersion = $Installed.Version
        }
        Else{
            #Not installed or manually imported
            return
        }
        
        # Lookup the latest version Online
        $Online = Find-Module -Name $Module -Repository PSGallery -ErrorAction Stop
        $OnlineVersion = $Online.Version  
    
        # Compare the versions
        If ([System.Version]$OnlineVersion -gt [System.Version]$InstalledVersion) {
            
            # Uninstall the old version
            If($CheckOnly){
                Write-LMHost "[INFO]: You are currently using an outdated version ($InstalledVersion) of $Module, please consider upgrading to the latest version ($OnlineVersion) as soon as possible. Use the -AutoUpdateModule switch next time you connect to auto upgrade to the latest version." -ForegroundColor Yellow
            }
            ElseIf ($UninstallFirst -eq $true) {
                Write-LMHost "[INFO]: You are currently using an outdated version ($InstalledVersion) of $Module, uninstalling prior Module $Module version $InstalledVersion" -ForegroundColor Yellow
                Uninstall-Module -Name $Module -Force -Verbose:$False
    
                Write-LMHost "[INFO]: Installing newer Module $Module version $OnlineVersion."
                Install-Module -Name $Module -Force -AllowClobber -Verbose:$False -MinimumVersion $OnlineVersion
                Update-LogicMonitorModule -CheckOnly -Modules @($Module)
            }
            Else{
                Write-LMHost "[INFO]: You are currently using an outdated version ($InstalledVersion) of $Module. Installing newer Module $Module version $OnlineVersion." -ForegroundColor Yellow
                Install-Module -Name $Module -Force -AllowClobber -Verbose:$False -MinimumVersion $OnlineVersion
                Update-LogicMonitorModule -CheckOnly -Modules @($Module)
            }
            
        } 
        Else {
            Write-LMHost "[INFO]: Module $Module version $InstalledVersion is the latest version."
        }
    }
}