Function Initialize-LMPOVSetup {

    [CmdletBinding()]
    Param (
        [String]$Website,

        [String]$WebsiteHttpType = "https",

        [Switch]$SetupWebsite,

        [Switch]$SetupPortalMetrics,

        [Switch]$MoveMinimalMonitoring,

        [Switch]$CleanupDynamicGroups,

        [Switch]$RunAll
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($global:LMAuth.Valid) {
            #Create readonly API use for Portal Metrics
            If ($SetupPortalMetrics -or $RunAll) {
                Write-Host "[INFO]: Setting up API user: lm_api"
                $APIUser = New-LMAPIUser -Username "lm_api" -note "Auto provisioned for use with LM Portal Metrics Datasources" -RoleNames @("readonly")
                If ($APIUser) {
                    Write-Host "[INFO]: Successfully setup API user: lm_api"
    
                    Write-Host "[INFO]: Creating readonly API token for user: lm_api"
                    $APIInfo = New-LMAPIToken -id $APIUser.id -Note "Auto provisioned for use with LM Portal Metrics Datasource"
                }
    
                #Setup portal mertics device if we have a valid API token
                If ($APIInfo) {
                    Write-Host "[INFO]: Successfully created API token for user: lm_api"
                    $PortalName = (Get-LMPortalInfo).companydisplayname
    
                    If ($PortalName) {
                        $PortalDeviceGroup = New-LMDeviceGroup -Name "LogicMonitor Portal Metrics" -AppliesTo "hasCategory(`"LogicMonitorPortal`")" -ParentGroupName "Devices by Type"
                        If ($PortalDeviceGroup) {
                            Write-Host "[INFO]: Created Portal Metrics dynamic group in Devices by Type: $($PortalDeviceGroup.name)"
                        }

                        $DeviceName = "$PortalName.logicmonitor.com"
                        $CollectorId = (Get-LMCollector | Select-Object -Last 1).id
                        Write-Host "[INFO]: Creating Portal Metrics resource: $DeviceName"
                        $PortalDevice = New-LMDevice -Name $DeviceName -DisplayName $DeviceName -Description "Auto provisioned resource to collect LM Portal Metrics" -Properties @{"lmaccess.id" = $APIInfo.accessId; "lmaccess.key" = $APIInfo.accessKey; "lmaccount" = $PortalName } -PreferredCollectorId  $CollectorId
                        If ($PortalDevice) {
                            Write-Host "[INFO]: Successfully created Portal Metrics resource: $DeviceName"
                        }
                    }
                }
            }

            #Setup Company Website
            If ($SetupWebsite -or $RunAll) {
                Write-Host "[INFO]: Setting up external webcheck for: $Website"
                $WebsiteResult = New-LMWebsite -Type "webcheck" -Name $Website -HttpType $WebsiteHttpType -Hostname $Website
                If ($WebsiteResult) {
                    Write-Host "[INFO]: Successfully setup external webcheck for: $Website"
                }
            }

            #Move minimal monitoring folder into devices by type
            If ($MoveMinimalMonitoring -or $RunAll) {
                $DeviceFolderId = (Get-LMDeviceGroup -Name "Devices by Type").id
                $MinimalFolderId = (Get-LMDeviceGroup -Name "Minimal Monitoring").id
                If ($DeviceFolderId -and $MinimalFolderId) {
                    Write-Host "[INFO]: Moving minimal monitoring folder into Devices by Type"
                    $MinimalFolderGroup = Set-LMDeviceGroup -id 15 -ParentGroupId 2
                    If ($MinimalFolderGroup) {
                        Write-Host "[INFO]: Successfully moved minimal monitoring folder into Devices by Type"
                    }
                }
            }

            #Cleanup dynamic groups will add Linux_SSH to the Linux folder and delete the Misc folder
            If ($CleanupDynamicGroups -or $RunAll) {
                Write-Host "[INFO]: Cleaning up default dynamic groups"
                $LinuxDeviceGroupId = (Get-LMDeviceGroup -Name "Linux Servers").id
                $MiscDeviceGroupId = (Get-LMDeviceGroup -Name "Misc").id
                If ($LinuxDeviceGroupId) {
                    $ModifedLinuxGroup = Set-LMDeviceGroup -Id $LinuxDeviceGroupId -AppliesTo "isLinux() || hasCategory(`"Linux_SSH`")"
                    If ($ModifedLinuxGroup) {
                        Write-Host "[INFO]: Updated Linux Servers group to include Linux_SSH devices"
                    }

                }
                If ($MiscDeviceGroupId) {
                    $MiscDeviceGroup = Remove-LMDeviceGroup -Id $MiscDeviceGroupId
                    If ($ModifedLinuxGroup) {
                        Write-Host "[INFO]: Removed Misc devices group from Devices by Type"
                    }

                }
            }
            
        }
        Else {
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
