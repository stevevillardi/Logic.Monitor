
Function Initialize-LMPOVSetup {

    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Individual')]
        [String]$Website,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Individual')]
        [String]$WebsiteHttpType = "https",

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Individual')]
        [string]$PortalMetricsAPIUsername = "lm_portal_metrics",

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Individual')]
        [string]$LogsAPIUsername = "lm_logs",

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupWebsite,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupPortalMetrics,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupLMContainer,

        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Individual')]
        [string]$LMContainerAPIUsername = "lm_container",

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$MoveMinimalMonitoring,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$CleanupDynamicGroups,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupWindowsLMLogs,

        [Parameter(ParameterSetName = 'Individual')]
        [Parameter(ParameterSetName = 'All')]
        [Switch]$IncludeDefaults,

        [Parameter(ParameterSetName = 'PostPOV-Readonly')]
        [Switch]$ReadOnlyMode,

        [Parameter(ParameterSetName = 'PostPOV-RevertReadonly')]
        [Switch]$RevertReadOnlyMode,

        [Parameter(ParameterSetName = 'Individual')]
        [Switch]$SetupCollectorServiceInsight,
        
        [Parameter(ParameterSetName = 'All')]
        [Parameter(ParameterSetName = 'Individual')]
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

            #Generate hastable of new dynamic groups to create
            $DynamicGroupList = @{
                "All Devices" = 'true()'
                "AWS Resources" = 'isAWSService()'
                "Azure Resources" = 'isAzureService()'
                "GCP Resources" = 'isGCPService()'
                "K8s Resources" = 'system.devicetype == "8"'
                "Dead Devices" = 'system.hoststatus == "dead" || system.hoststatus == "dead-collector" || system.gcp.status == "TERMINATED" || system.azure.status == "PowerState/stopped" || system.aws.stateName == "terminated"'
                "Palo Alto" = 'hasCategory("PaloAlto")'
                "Cisco ASA" = 'hasCategory("CiscoASA")'
                "Logs Enabled Devices" = 'hasPushModules("LogUsage")'
                "Netflow Enabled Devices" = 'isNetflow()'
                "Cisco UCS" = 'hasCategory("CiscoUCSFabricInterconnect") || hasCategory("CiscoUCSManager")'
                "Oracle" = 'hasCategory("OracleDB")'
                "Domain Controllers" = 'hasCategory("MicrosoftDomainController")'
                "Exchange Servers" = 'hasCategory("MSExchange")'
                "IIS" = 'hasCategory("MicrosoftIIS")'
                "Citrix XenApp" = 'hasCategory("CitrixBrokerActive") || hasCategory("CitrixMonitorServiceV2") || hasCategory("CitrixLicense") || hasCategory("CitrixEUEM")'

            }

            #If readonly mode, siwtch all users to readonly and record previous role permissions for role back
            If($ReadOnlyMode){
                $Users = Get-LMUser | Where-Object {$_.apionly -eq $False -and $_.username -ne "lmsupport"}
                Foreach($User in $Users){
                    If($User.Note -notlike "Previous Roles:*"){
                        $PreviousRoles = $User.roles.Name -Join(",")
                        $UpdatedUser = Set-LMUser -Id $User.Id -RoleNames @("readonly") -Note "Previous Roles: $PreviousRoles"
                        If($UpdatedUser){
                            Write-Host "[INFO]: Previous role info ($($User.roles.Name -Join(","))) stored for user $($User.username), successfully converted to readonly role." -ForegroundColor Yellow
                        }
                    }
                    Else{
                        Write-Host "[INFO]: User $($User.username) previously converted, skipping processing." -ForegroundColor Gray
                    }
                }
            }
            #Revert any previous set readonly roles back to their original state
            If($RevertReadOnlyMode){
                $Users = Get-LMUser | Where-Object {$_.apionly -eq $False -and $_.username -ne "lmsupport"}
                Foreach($User in $Users){
                    $PreviousRoles = ($User.Note -Split "Previous Roles: ")[1] -Split (",")
                    If($PreviousRoles){
                        $UpdatedUser = Set-LMUser -Id $User.Id -RoleNames $PreviousRoles -Note " "
                        If($UpdatedUser){
                            Write-Host "[INFO]: Previous role info ($(($User.Note -Split "Previous Roles: ")[1])) found for user $($User.username), successfully reverted readonly role." -ForegroundColor Yellow
                        }
                    }
                    Else{
                        Write-Host "[WARN]: No previous role info found for user $($User.username), skipping role revert for user." -ForegroundColor Yellow
                    }
                }
            }

            #Setup common default options/imports
            If($IncludeDefaults){
                #Set SSL_Cert DS to only alert on non self signed certs
                $SSLDatasourceName = "SSL_Certificates"
                $SSLDatasource = Get-LMDatasource -name $SSLDatasourceName
                If($SSLDatasource){
                    If($SSLDatasource.dataPoints.name.IndexOf("Alerting_DaysRemainingIfNotSelfSigned") -ne 1 -and $SSLDatasource.dataPoints.name.IndexOf("DaysRemaining") -ne 1){
                        Try{
                            $SSLDatasource.dataPoints[$SSLDatasource.dataPoints.name.IndexOf("Alerting_DaysRemainingIfNotSelfSigned")].alertExpr = "< 28 7 2"
                            $SSLDatasource.dataPoints[$SSLDatasource.dataPoints.name.IndexOf("DaysRemaining")].alertExpr = $null
                            $SSLResult = Set-LMDatasource -Id $SSLDatasource.id -Datapoints $SSLDatasource.datapoints -ErrorAction Stop
                            Write-Host "[INFO]: Successfully updated default alert thresholds on LogicModule ($SSLDatasourceName)"
                        }
                        Catch{
                            Write-Host "[ERROR]: Unable to modify default alert thresholds on LogicModule ($SSLDatasourceName): $_" -ForegroundColor Red
                        }
                    }
                    Else{
                        #Unable to find required datapoints for modification
                        Write-Host "[ERROR]: Unable to modify default alert thresholds on LogicModule ($SSLDatasourceName), expected datapoints not found" -ForegroundColor Red
                    }
                }
                Else{
                    #Unable to find SSL_Certificates DS
                    Write-Host "[ERROR]: Unable to locate LogicModule ($SSLDatasourceName), skipping alert threshold modification" -ForegroundColor Red
                }

                #Import default DSes
                $ModuleList = @(
                    @{
                        name = "Microsoft_Windows_Services_AD.xml"
                        type = "datasource"
                    },
                    @{
                        name = "LogicMonitor_Collector_Configurations.xml"
                        type = "configsource"
                    },
                    @{
                        name = "NoData_Metrics.xml"
                        type = "datasource"
                    },
                    @{
                        name = "NoData_Tasks_By_Type_v2.xml"
                        type = "datasource"
                    },
                    @{
                        name = "NoData_Tasks_Overall_v2.xml"
                        type = "datasource"
                    },
                    @{
                        name = "NoData_Tasks_Discovery_v2.json"
                        type = "propertyrules"
                    }
                )
                Foreach($Module in $ModuleList){
                    $ModuleName = $Module.name.Split(".")[0]
                    $LogicModule = Switch($Module.type){
                        "datasource" {Get-LMDataSource -name $ModuleName}
                        "configsource" {Get-LMConfigSource -name $ModuleName}
                        "propertyrules" {Get-LMPropertySource -name $ModuleName}
                        default {Get-LMDataSource -name $ModuleName}
                    }
                    If(!$LogicModule){                
                        Try{
                            $LogicModule = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/stevevillardi/Logic.Monitor/main/Private/SIs/$($Module.name)").Content
                            Import-LMLogicModule -File $LogicModule -Type $Module.type -ErrorAction Stop
                            Write-Host "[INFO]: Successfully imported $ModuleName datasource"
                        }
                        Catch{
                            #Oops
                            Write-Host "[ERROR]: Unable to import $ModuleName LogicModule from source: $_" -ForegroundColor Red
                        }
                    }
                    Else{
                        Write-Host "[INFO]: LogicModule $ModuleName already exists, skipping import" -ForegroundColor Gray
                    }
                }
            }

            #Create example collector service insight
            If($SetupCollectorServiceInsight -or $RunAll){
                $ServiceInsightProps = @{
                    device = @(
                        @{
                            deviceGroupFullPath = "Devices by Type/Collectors";
                            deviceDisplayName = "*";
                            deviceProperties = @()
                        }
                    )
                } | ConvertTo-Json -Depth 3

                #Create new SI resource
                $ServiceInsightResource = Get-LMDevice -name "LogicMonitorCollectorHealth"
                If(!$ServiceInsightResource){
                    $ServiceInsightResource = New-LMDevice -name "LogicMonitorCollectorHealth" -DisplayName "LogicMonitor: Collector Health" -PreferredCollectorId -4 -DeviceType 6 -Properties @{"predef.bizservice.members"=$ServiceInsightProps;"predef.bizService.evalMembersInterval"="30"}
                    If($ServiceInsightResource){
                        Write-Host "[INFO]: Successfully created service insight resource (LogicMonitor: Collector Health)"
                        #Upload SI datasource from xml
                        Try{
                            $SIDatasource = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/stevevillardi/Logic.Monitor/main/Private/SIs/LogicMonitor_Collector_Health.xml" -UseBasicParsing).Content
                            Import-LMLogicModule -File $SIDatasource -Type datasource -ErrorAction Stop
                        }
                        Catch{
                            #Oops
                            Write-Host "[ERROR]: Unable to import SI template from source: $_" -ForegroundColor Red
                        }
                    }
                    Else{
                        #Oops
                        Write-Host "[ERROR]: Failed to create service insight resource (LogicMonitor: Collector Health), review error message and try again." -ForegroundColor Red
                    }
                }
                Else{
                    Write-Host "[INFO]: Service insight resource (LogicMonitor: Collector Health) already exists, skipping creation" -ForegroundColor Gray
                    #Upload SI datasource from xml
                    If(!$(Get-LMDatasource -DisplayName "LogicMonitor Collector Health")){
                        Try{
                            $SIDatasource = (Invoke-WebRequest -Uri "https://raw.githubusercontent.com/stevevillardi/Logic.Monitor/main/Private/SIs/LogicMonitor_Collector_Health.xml").Content
                            Import-LMLogicModule -File $SIDatasource -Type datasource -ErrorAction Stop
                        }
                        Catch{
                            #Oops
                            Write-Host "[WARN]: Unable to import SI template from source: $_" -ForegroundColor Yellow
                        }
                    }
                    Else{
                        Write-Host "[INFO]: Service insight aggregate datasource (LogicMonitor Collector Health) already exists, skipping import" -ForegroundColor Gray
                    }
                }
            }

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
                    Write-Host "[INFO]: API User ($PortalMetricsAPIUsername) or portal metrics device ($DeviceName) already exists in portal, skipping setup for portal metrics" -ForegroundColor Gray
                }
            }

            #Setup Company Website
            If (($SetupWebsite -or $RunAll) -and $Website) {
                Write-Host "[INFO]: Setting up external webcheck for: $Website"
                $Website = $Website.split("//")[-1] #Make sure http/https is not in the entered site name
                $WebsiteResult = New-LMWebsite -Type "webcheck" -Name $Website -HttpType $WebsiteHttpType -WebsiteDomain $Website
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
                    $MinimalFolderGroup = Set-LMDeviceGroup -id $MinimalFolderId -ParentGroupId $DeviceFolderId
                    If ($MinimalFolderGroup) {
                        Write-Host "[INFO]: Successfully moved minimal monitoring folder into Devices by Type"
                    }
                    $MinimalFolderAppliesTo = (Get-LMDeviceGroup -Name "Minimal Monitoring").appliesTo
                    If ($MinimalFolderAppliesTo) {
                        Write-Host "[INFO]: Updating Minimal Monitoring folder to exclude Meraki and Portal Metrics resources"
                        $MinimalFolderAppliesTo = "system.sysinfo == `"`" && system.sysoid == `"`" && isDevice() && !(system.virtualization) && (monitoring != `"basic`") && system.devicetype != `"8`" && !hasCategory(`"LogicMonitorPortal`")  && !hasCategory(`"MerakiAPIOrg`")  && !hasCategory(`"MerakiAPINetwork`")"
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
                $LinuxDeviceGroupId = (Get-LMDeviceGroup -Name "Linux Servers" | Where-Object {$_.fullPath -like "Devices by Type*"}).id
                $MiscDeviceGroupId = (Get-LMDeviceGroup -Name "Misc").id
                If(!$DeviceFolderId){
                    $DeviceFolderId = (Get-LMDeviceGroup -Name "Devices by Type").id
                }
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
                Write-Host "[INFO]: Creating additional default dynamic groups"
                Foreach($Group in $DynamicGroupList.GetEnumerator()){
                    If(!$(Get-LMDeviceGroup -Name $Group.Name)){
                        $NewGroup = New-LMDeviceGroup -Name $Group.Name -ParentGroupId $DeviceFolderId -AppliesTo $Group.Value
                        If($NewGroup){
                            Write-Host "[INFO]: Created new dynamic group: $($Group.Name)"
                        }
                    }
                    Else{
                        Write-Host "[INFO]: Dynamic group: $($Group.Name) already exists, skipping creation" -ForegroundColor Gray
                    }
                }
            }

            #Add k8s role with proper permissions
            If($RunAll -or $SetupLMContainer){
                $LMContainerAPIRoleName = "lm-container"
                $LMContainerAPIUser = Get-LMUser -Name "$LMContainerAPIUsername"
                $LMContainerAPIRole = Get-LMRole -Name $LMContainerAPIRoleName

                If(!$LMContainerAPIRole){
                    Write-Host "[INFO]: Setting up LM Container API Role: $LMContainerAPIRoleName"
                    $LMContainerAPIRole = New-LMRole -Name $LMContainerAPIRoleName -ResourcePermission manage -LogsPermission manage -DashboardsPermission manage -SettingsPermission manage-collectors -Description "Auto provisioned to allow for API token creation for use with lm-container"
                    If($LMContainerAPIRole){
                        Write-Host "[INFO]: Successfully setup API role: $LMContainerAPIRoleName"
                    }
                }
                Else{
                    Write-Host "[INFO]: LM Container API Role ($LMContainerAPIRoleName) already exists in portal, skipping setup" -ForegroundColor Gray
                }

                If(!$LMContainerAPIUser){
                    Write-Host "[INFO]: Setting up LM Container API user: $LMContainerAPIUsername"
                    $LMContainerAPIUser = New-LMAPIUser -Username "$LMContainerAPIUsername" -note "Auto provisioned for use with LM Container" -RoleNames @($LMContainerAPIRoleName)
                    If ($LMContainerAPIUser) {
                        Write-Host "[INFO]: Successfully setup API user: $LMContainerAPIUsername"
                    }
                }
            }

            If($SetupWindowsLMLogs -or $RunAll){
                $LogsAPIRoleName = "lm-logs-ingest"
                $LogsAPIUser = Get-LMUser -Name "$LogsAPIUsername"
                $LogsAPIRole = Get-LMRole -Name $LogsAPIRoleName
                If(!$LogsAPIRole){
                    Write-Host "[INFO]: Setting up LM Logs API Role: $LogsAPIRoleName"
                    $LogsAPIRole = New-LMRole -Name $LogsAPIRoleName -ResourcePermission view -LogsPermission manage -Description "Auto provisioned to allow for windows events ingest via datasource"
                    If($LogsAPIRole){
                        Write-Host "[INFO]: Successfully setup API role: $LogsAPIRoleName"
                    }
                }
                Else{
                    Write-Host "[INFO]: LM Logs API Role ($LogsAPIRoleName) already exists in portal, skipping setup" -ForegroundColor Gray
                }

                If(!$LogsAPIUser){
                    Write-Host "[INFO]: Setting up LM Logs API user: $LogsAPIUsername"
                    $LogsAPIUser = New-LMAPIUser -Username "$LogsAPIUsername" -note "Auto provisioned for use with Windows LM Logs Datasource" -RoleNames @($LogsAPIRoleName)
                    If ($LogsAPIUser) {
                        Write-Host "[INFO]: Successfully setup API user: $LogsAPIUsername"
        
                        Write-Host "[INFO]: Creating administrator API token for user: $LogsAPIUsername"
                        $LMLogsAPIINfo = New-LMAPIToken -id $LogsAPIUser.id -Note "Auto provisioned for use with Windows LM Logs Datasource"
                    }
        
                    #Import Datasource and apply properties to windows server group
                    If ($LMLogsAPIINfo) {
                        Write-Host "[INFO]: Successfully created API token for user: $LogsAPIUsername | $($LMLogsAPIINfo.accessId) | $($LMLogsAPIINfo.accessKey)"
        
                        $WindowsServerDeviceGroup =  Get-LMDeviceGroup -Name "Windows Servers" | Where-Object {$_.fullPath -like "Devices by Type*"}


                        If ($WindowsServerDeviceGroup) {
                            Write-Host "[INFO]: Adding API properties to Windows Server device group"
                            $UpdatedWindowsServerDeviceGroup = Set-LMDeviceGroup -Id $WindowsServerDeviceGroup.Id -Properties @{"lmaccess.id" = $LMLogsAPIINfo.accessId; "lmaccess.key" = $LMLogsAPIINfo.accessKey; "lmaccount" = $PortalName; "lmlogs.winevent.channels" = $WindowsLMLogsEventChannels; "lmlogs.winevent.detailed_message" = "false" }
                            If ($UpdatedWindowsServerDeviceGroup) {
                                Write-Host "[INFO]: Successfully updated Windows Server device group for LM Logs"
                            }
                        }


                    }
                }
                Else{
                    Write-Host "[INFO]: LM Logs API User ($LogsAPIUsername) already exists in portal, skipping setup" -ForegroundColor Gray
                }

                #Import LM Logs Datasource
                $LogsDatasource = Get-LMDatasource -Name "Windows_Events_LMLogs"
                If(!$LogsDatasource){
                    Import-LMExchangeModule -LMExchangeId "2cb0a988-487a-48a6-b332-62003ef3b3dc" #core module
                    Start-Sleep -Seconds 5 #Added manual pause to ensure datasource is available after importing from the exchange
                    $LogsDatasource = Set-LMDatasource -Name Windows_Events_LMLogs -appliesTo "isWindows() && lmlogs.winevent.channels && lmaccess.id && lmaccess.key && lmaccount"
                    If($LogsDatasource){
                        Write-Host "[INFO]: Successfully added core module (Windows_Events_LMLogs) and updated appliesto logic"
                    }
                    Else{
                        Write-Host "[WARN]: Successfully added core module (Windows_Events_LMLogs) but was unable to modify the appliesTo criteria, please manually set the appliesTo criteria for the datasource to apply: 'isWindows() && lmlogs.winevent.channels && lmaccess.id && lmaccess.key && lmaccount'" -ForegroundColor Yellow
                    }
                }
                Else{
                    Write-Host "[INFO]: LM Logs core logicmodule ($($LogsDatasource.displayname)) already exists in portal, skipping setup" -ForegroundColor Gray
                }
            }
            
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
