
Function Initialize-LMPOVSetup {

    [CmdletBinding()]
    Param (
        [String]$Website,

        [String]$WebsiteHttpType = "https",

        [string]$PortalMetricsAPIUsername = "lm_api",

        [string]$LogsAPIUsername = "lm_logs",

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupWebsite,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupPortalMetrics,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$MoveMinimalMonitoring,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$CleanupDynamicGroups,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupWindowsLMLogs,

        [String]$WindowsLMLogsEventChannels = "Application,System",

        [Parameter(ParameterSetName = 'All')]
        [Switch]$RunAll
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            $PortalName = $Script:LMAuth.Portal
            $DeviceName = "$PortalName.logicmonitor.com"

            #Create readonly API use for Portal Metrics
            If ($SetupPortalMetrics -or $RunAll) {
                $CheckAPIUser = Get-LMUser -Name "$PortalMetricsAPIUsername"
                $CheckPortalDevice = Get-LMDevice -Name $DeviceName

                If(!$CheckAPIUser -and !$CheckPortalDevice){
                    Write-Host "[INFO]: Setting up API user: $PortalMetricsAPIUsername"
                    $APIUser = New-LMAPIUser -Username "$PortalMetricsAPIUsername" -note "Auto provisioned for use with LM Portal Metrics Datasources" -RoleNames @("readonly")
                    If ($APIUser) {
                        Write-Host "[INFO]: Successfully setup API user: $PortalMetricsAPIUsername"
        
                        Write-Host "[INFO]: Creating readonly API token for user: $PortalMetricsAPIUsername"
                        $APIInfo = New-LMAPIToken -id $APIUser.id -Note "Auto provisioned for use with LM Portal Metrics Datasource"
                    }
        
                    #Setup portal mertics device if we have a valid API token
                    If ($APIInfo) {
                        Write-Host "[INFO]: Successfully created API token for user: $PortalMetricsAPIUsername | $($APIInfo.accessId) | $($APIInfo.accessKey)"
        
                        If ($PortalName) {
                            $PortalDeviceGroup = New-LMDeviceGroup -Name "LogicMonitor Portal Metrics" -AppliesTo "hasCategory(`"LogicMonitorPortal`")" -ParentGroupName "Devices by Type"
                            If ($PortalDeviceGroup) {
                                Write-Host "[INFO]: Created Portal Metrics dynamic group in Devices by Type: $($PortalDeviceGroup.name)"
                            }
    
                            $CollectorId = (Get-LMCollector | Where-Object {$_.collectorSize -ne "n/a"} | Select-Object -Last 1).id
                            Write-Host "[INFO]: Creating Portal Metrics resource: $DeviceName"
                            $PortalDevice = New-LMDevice -Name $DeviceName -DisplayName $DeviceName -Description "Auto provisioned resource to collect LM Portal Metrics" -Properties @{"lmaccess.id" = $APIInfo.accessId; "lmaccess.key" = $APIInfo.accessKey; "lmaccount" = $PortalName } -PreferredCollectorId  $CollectorId
                            If ($PortalDevice) {
                                Write-Host "[INFO]: Successfully created Portal Metrics resource: $DeviceName"
                            }
                        }
                    }
                }
                Else{
                    Write-Host "[INFO]: API User ($PortalMetricsAPIUsername) or portal metrics device ($DeviceName) already exists in portal, skipping setup for portal metrics" -ForegroundColor Yellow
                }
            }

            #Setup Company Website
            If (($SetupWebsite -or $RunAll) -and $Website) {
                Write-Host "[INFO]: Setting up external webcheck for: $Website"
                $Website = $Website.split("//")[-1] #Make sure http/https is not in the entered site name
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
                    $MinimalFolderAppliesTo = (Get-LMDeviceGroup -Name "Minimal Monitoring").appliesTo
                    If ($MinimalFolderAppliesTo) {
                        Write-Host "[INFO]: Updating Minimal Monitoring folder to exclude Meraki and Portal Metrics resources"
                        $MinimalFolderAppliesTo = $MinimalFolderAppliesTo + " && !hasCategory(`"LogicMonitorPortal`")  && !hasCategory(`"MerakiAPIOrg`")  && !hasCategory(`"MerakiAPINetwork`")"
                        $MinimalFolder = Set-LMDeviceGroup -Id $MinimalFolderId -AppliesTo $MinimalFolderAppliesTo
                        If ($MinimalFolder) {
                            Write-Host "[INFO]: Successfully updated minimal monitoring appliesTo query"
                        }
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

            If($SetupWindowsLMLogs -or $RunAll){
                $LogsAPIUser = Get-LMUser -Name "$LogsAPIUsername"

                If(!$LogsAPIUser){
                    Write-Host "[INFO]: Setting up LM Logs API user: $LogsAPIUsername"
                    $LogsAPIUser = New-LMAPIUser -Username "$LogsAPIUsername" -note "Auto provisioned for use with Windows LM Logs Datasource" -RoleNames @("administrator")
                    If ($LogsAPIUser) {
                        Write-Host "[INFO]: Successfully setup API user: $LogsAPIUsername"
        
                        Write-Host "[INFO]: Creating administrator API token for user: $LogsAPIUsername"
                        $LMLogsAPIINfo = New-LMAPIToken -id $LogsAPIUser.id -Note "Auto provisioned for use with Windows LM Logs Datasource"
                    }
        
                    #Import Datasource and apply properties to windows server group
                    If ($LMLogsAPIINfo) {
                        Write-Host "[INFO]: Successfully created API token for user: $LogsAPIUsername | $($LMLogsAPIINfo.accessId) | $($LMLogsAPIINfo.accessKey)"
        
                        $WindowsServerDeviceGroup = Get-LMDeviceGroup -Name "Windows Servers"

                        If ($WindowsServerDeviceGroup) {
                            Write-Host "[INFO]: Adding API properties to Windows Server device group"
                            $UpdatedWindowsServerDeviceGroup = Set-LMDeviceGroup -Id $WindowsServerDeviceGroup.Id -Properties @{"lmaccess.id" = $LMLogsAPIINfo.accessId; "lmaccess.key" = $LMLogsAPIINfo.accessKey; "lmaccount" = $PortalName; "lmlogs.winevent.channels" = $WindowsLMLogsEventChannels; "lmlogs.winevent.detailed_message" = "false" }
                            If ($UpdatedWindowsServerDeviceGroup) {
                                Write-Host "[INFO]: Successfully updated Windows Server device group for LM Logs"
                            }
                        }


                    }
                    #Import LM Logs Datasource
                    #Import-LMExchangeModule -LMExchangeId "ed2eaf02-8c48-4e41-a7f9-8fd3d96c8e5a"
                    #Use Kevin Fords imporved version with metadata over the orginal version
                    Import-LMExchangeModule -LMExchangeId "896d0c2c-a993-4f0b-8db2-2bb29947cb52"
                }
                Else{
                    Write-Host "[INFO]: LM Logs API User ($LogsAPIUsername) already exists in portal, skipping setup" -ForegroundColor Yellow
                }
            }
            
        }
        Else {
            Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
