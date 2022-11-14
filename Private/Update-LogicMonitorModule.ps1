# Auto-Update PowerShell
Function Update-LogicMonitorModule {
    Param (
        [String]$Module = 'Logic.Monitor',
        [Boolean]$UninstallFirst = $False,
        [Switch]$CheckOnly
    )

    # Read the currently installed version
    $Installed = Get-Module -ListAvailable -Name $Module

    # There might be multiple versions
    If ($Installed -is [Array]) {
        $InstalledVersion = $Installed[0].Version
    }
    Else {
        $InstalledVersion = $Installed.Version
        If(!$InstalledVersion){
            #Should not be possible, but even so just return if module is not detected
            return
        }
    }
    
    # Lookup the latest version Online
    $Online = Find-Module -Name $Module -Repository PSGallery -ErrorAction Stop
    $OnlineVersion = $Online.Version  

    # Compare the versions
    If ([System.Version]$OnlineVersion -gt [System.Version]$InstalledVersion) {
        
        # Uninstall the old version
        If($CheckOnly){
            Write-LMHost "You are currently using an outdated version ($InstalledVersion) of Logic.Monitor, please consider upgrading to the latest version ($OnlineVersion) as soon as possible." -ForegroundColor Yellow
        }
        ElseIf ($UninstallFirst -eq $true) {
            Write-LMHost "Uninstalling prior Module $Module version $InstalledVersion"
            Uninstall-Module -Name $Module -Force -Verbose:$False
        }
        Else{
            Write-LMHost "Installing newer Module $Module version $OnlineVersion"
            Install-Module -Name $Module -Force -AllowClobber -Verbose:$False
        }
        
    } 
    Else {
        Write-LMHost "Module $Module version $InstalledVersion is the latest version."
    }
}