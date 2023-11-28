Function New-LMRole {

    [CmdletBinding(DefaultParameterSetName = 'Default')]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Custom')]
        [Parameter(Mandatory,ParameterSetName = 'Default')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$CustomHelpLabel,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$CustomHelpURL,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$Description,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [Switch]$RequireEULA,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [Boolean]$TwoFARequired = $true,

        [Parameter(ParameterSetName = 'Default')]
        [Parameter(ParameterSetName = 'Custom')]
        [String]$RoleGroupId = 1,

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage","none")]
        [String]$DashboardsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage","none")]
        [String]$ResourcePermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage","none")]
        [String]$LogsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage","none")]
        [String]$WebsitesPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage","none")]
        [String]$SavedMapsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage","none")]
        [String]$ReportsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [ValidateSet("view", "manage","none","manage-collectors","view-collectors")]
        [String]$SettingsPermission = "none",

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$CreatePrivateDashboards,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$AllowWidgetSharing,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$ConfigTabRequiresManagePermission,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$AllowedToViewMapsTab,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$AllowedToManageResourceDashboards,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$ViewTraces,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$ViewSupport,

        [Parameter(ParameterSetName = 'Default')]
        [Switch]$EnableRemoteSessionForResources,

        [Parameter(Mandatory,ParameterSetName = 'Custom')]
        [PSCustomObject]$CustomPrivilegesObject

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        
        #Build header and uri
        $ResourcePath = "/setting/roles"
        $Privileges = @()

        If(!$CustomPrivilegesObject){

            If($ViewTraces){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "tracesManageTab"
                    operation = "read"
                    subOperation = ""
                }
            }

            If($EnableRemoteSessionForResources){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "remoteSession"
                    operation = "write"
                    subOperation = ""
                }
            }

            If($AllowedToViewMapsTab){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "resourceMapTab"
                    operation = "read"
                    subOperation = ""
                }
            }

            If($AllowWidgetSharing){
                $Privileges += [PSCustomObject]@{
                    objectId = "sharingwidget"
                    objectName = "sharingwidget"
                    objectType = "dashboard_group"
                    operation = "write"
                    subOperation = ""
                }
            }

            If($CreatePrivateDashboards){
                $Privileges += [PSCustomObject]@{
                    objectId = "private"
                    objectName = "private"
                    objectType = "dashboard_group"
                    operation = "write"
                    subOperation = ""
                }
            }

            If($ViewSupport){
                $Privileges += [PSCustomObject]@{
                    objectId = "chat"
                    objectName = "help"
                    objectType = "help"
                    operation = "write"
                    subOperation = ""
                }
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "help"
                    objectType = "help"
                    operation = "read"
                    subOperation = ""
                }
            }
            Else{
                $Privileges += [PSCustomObject]@{
                    objectId = "chat"
                    objectName = "help"
                    objectType = "help"
                    operation = "read"
                    subOperation = ""
                }
            }

            $Privileges += [PSCustomObject]@{
                objectId = ""
                objectName = "configNeedDeviceManagePermission"
                objectType = "configNeedDeviceManagePermission"
                operation = If($ConfigTabRequiresManagePermission){"write"}Else{"read"}
                subOperation = ""
            }

            $Privileges += [PSCustomObject]@{
                objectId = ""
                objectName = "deviceDashboard"
                objectType = "deviceDashboard"
                operation = If($AllowedToManageResourceDashboards){"write"}Else{"read"}
                subOperation = ""
            }

            If($DashboardsPermission -ne "none"){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "dashboard_group"
                    operation = If($DashboardsPermission -eq "manage"){"write"}Else{"read"}
                    subOperation = ""
                }
            }

            If($ResourcePermission -ne "none"){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "host_group"
                    operation = If($ResourcePermission -eq "manage"){"write"}Else{"read"}
                    subOperation = ""
                }
            }

            If($LogsPermission -ne "none"){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "logs"
                    operation = If($LogsPermission -eq "manage"){"write"}Else{"read"}
                    subOperation = ""
                }
            }

            If($WebsitesPermission -ne "none"){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "website_group"
                    operation = If($WebsitesPermission -eq "manage"){"write"}Else{"read"}
                    subOperation = ""
                }
            }

            If($SavedMapsPermission -ne "none"){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "map"
                    operation = If($SavedMapsPermission -eq "manage"){"write"}Else{"read"}
                    subOperation = ""
                }
            }

            If($ReportsPermission -ne "none"){
                $Privileges += [PSCustomObject]@{
                    objectId = "*"
                    objectName = "*"
                    objectType = "report_group"
                    operation = If($ReportsPermission -eq "manage"){"write"}Else{"read"}
                    subOperation = ""
                }
            }

            If($SettingsPermission -ne "none"){
                If($SettingsPermission -ne "manage-collectors" -and $SettingsPermission -ne "view-collectors"){
                    $Privileges += [PSCustomObject]@{
                        objectId = "*"
                        objectName = "*"
                        objectType = "setting"
                        operation = If($SettingsPermission -eq "manage"){"write"}Else{"read"}
                        subOperation = ""
                    }

                    $Privileges += [PSCustomObject]@{
                        objectId = "useraccess.*"
                        objectName = "useraccess.*"
                        objectType = "setting"
                        operation = If($ResourcePermission -eq "manage"){"write"}Else{"read"}
                        subOperation = ""
                    }
                }
                Else{
                    $Privileges += [PSCustomObject]@{
                        objectId = "collectorgroup.*"
                        objectName = "Collectors"
                        objectType = "setting"
                        operation = If($SettingsPermission -eq "manage-collectors"){"write"}Else{"read"}
                    }
                }
            }

        }

        Try {
            $Data = @{
                customHelpLabel = $CustomHelpLabel
                customHelpURL   = $CustomHelpURL
                description     = $Description
                name            = $Name
                requireEULA      = $RequireEULA.IsPresent 
                roleGroupId     = $RoleGroupId
                twoFARequired   = $TwoFARequired
                privileges      = If($CustomPrivilegesObject){$CustomPrivilegesObject}Else{$Privileges}
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Role" )
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
