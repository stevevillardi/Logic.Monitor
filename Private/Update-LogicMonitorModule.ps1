# Auto-Update PowerShell
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
        Else {
            $InstalledVersion = $Installed.Version
            If(!$InstalledVersion){
                #Should not be possible unless using an unpublished version
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