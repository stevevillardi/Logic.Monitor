<#
.SYNOPSIS
Imports a Meraki Cloud portal into LM.

.DESCRIPTION
Imports a Meraki Cloud portal into LM along with creating any required groups and device properties.

.PARAMETER MerakiAPIToken
Meraki Dashboard API Token

.PARAMETER AllowedOrgIds
Array of Org Ids that you would like to import, if omitted all Org Ids will be imported

.PARAMETER AllowedNetworkIds
Array of Network Ids that you would like to import, if omitted all NetworkIds Ids will be imported

.PARAMETER MerakiRootFolderName
The main folder name for the Meraki import, if omitted the default name is Meraki

.PARAMETER MerakiFolderParentGroupId
The parent group id that the root meraki device group should exist under, if omitted will default to root of resource tree

.PARAMETER CollectorId
The collector id number to assign to created devices, if omitted devices will be assigned the first collector returned from Get-LMCollector

.PARAMETER ListOrgIds
List out the available org ids for a given Meraki Portal. Useful if you want to use the AllowedOrgIds filter but dont know the id/names of the orgs

.EXAMPLE
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxxxxxxxxxxxxxxx" -MerakiRootFolderName "Meraki Devices" -CollectorId 1 -MerakiFolderParentGroupId 1

.EXAMPLE
Import-LMMerakiCloud -MerakiAPIToken "xxxxxxxxxxxxxxxxxxxxx" -AllowedOrgIds @(1235,6234)

.NOTES
Currently a beta command, meraki cloud import is still under developement, please report any bugs you encounter while using this command.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>
Function Import-LMMerakiCloud {
    [CmdletBinding(DefaultParameterSetName="Import")]
    param (
        [Parameter(Mandatory, ParameterSetName = 'Import')]
        [Parameter(Mandatory, ParameterSetName = 'List')]
        [String]$MerakiAPIToken,

        [Parameter(ParameterSetName = 'Import')]
        [String[]]$AllowedOrgIds = $null,

        [Parameter(ParameterSetName = 'Import')]
        [String[]]$AllowedNetworkIds = $null,

        [Parameter(ParameterSetName = 'Import')]
        [String]$MerakiRootFolderName = "Meraki",

        [Parameter(ParameterSetName = 'Import')]
        [Int]$MerakiFolderParentGroupId = 1,

        [Parameter(ParameterSetName = 'Import')]
        [String]$CollectorId,

        [Parameter(ParameterSetName = 'List')]
        [Switch]$ListOrgIds,

        [Parameter(ParameterSetName = 'List')]
        [Switch]$ListSNMPInfo,

        [Parameter(ParameterSetName = 'List')]
        [Switch]$ListNetworkIds
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            #List out org devices
            If($ListOrgIds -or $ListNetworkIds -or $ListSNMPInfo){
                Try{
                    $Orgs = Invoke-RestMethod -Uri "https://api.meraki.com/api/v1/organizations" -Headers @{"X-Cisco-Meraki-API-Key"=$MerakiAPIToken}
                }
                Catch [Exception] {
                    If($_.Exception.Response.StatusCode.value__ -eq "401"){
                        Write-Host "Unathorized request, check API token and try again." -ForegroundColor Red
                        return
                    }
                    Else{
                        Write-Host "$($_.TargetObject.RequestUri.OriginalString): $(($_.ErrorDetails.Message | ConvertFrom-Json).errors)" -ForegroundColor Red
                    }
                }
                $MerkaiInfo = @()
                Foreach($Org in $Orgs){
                    If($ListSNMPInfo){
                        If($Org.api.enabled){
                            Try{
                                $SNMPInfo = Invoke-RestMethod -Uri "https://api.meraki.com/api/v1/organizations/$($Org.id)/snmp" -Headers @{"X-Cisco-Meraki-API-Key"=$MerakiAPIToken}
                            }
                            Catch{
                                If($_.Exception.Response.StatusCode.value__ -eq "401"){
                                    Write-Host "Unathorized request, check API token and try again." -ForegroundColor Red
                                    return
                                }
                                Else{
                                    Write-Host "$($_.TargetObject.RequestUri.OriginalString): $(($_.ErrorDetails.Message | ConvertFrom-Json).errors)" -ForegroundColor Red
                                    Continue
                                }
                            }
                            $MerkaiInfo += [PSCustomObject]@{
                                orgId = $Org.id
                                orgName = $Org.name
                                v2cEnabled = $SNMPInfo.v2cEnabled
                                v3Enabled = $SNMPInfo.v3Enabled
                                v3AuthMode = $SNMPInfo.v3AuthMode
                                v3PrivMode = $SNMPInfo.v3PrivMode
                                peerIps = $SNMPInfo.peerIps
                                v2CommunityString = $SNMPInfo.v2CommunityString
                                hostname = $SNMPInfo.hostname
                                port = $SNMPInfo.port
                            }
                        }
                        Else{
                            Write-Host "Skipping SNMP Info check for ($($Org.name)) since dashboard api access is disabled for that org." -ForegroundColor Yellow
                            Continue
                        }
                    }
                    ElseIf($ListNetworkIds){
                        If($Org.api.enabled){
                            Try{
                                $Networks = Invoke-RestMethod -Uri "https://api.meraki.com/api/v1/organizations/$($Org.id)/networks" -Headers @{"X-Cisco-Meraki-API-Key"=$MerakiAPIToken}
                            }
                            Catch [Exception] {
                                If($_.Exception.Response.StatusCode.value__ -eq "401"){
                                    Write-Host "Unathorized request, check API token and try again." -ForegroundColor Red
                                    return
                                }
                                Else{
                                    Write-Host "$($_.TargetObject.RequestUri.OriginalString): $(($_.ErrorDetails.Message | ConvertFrom-Json).errors)" -ForegroundColor Red
                                    Continue
                                }
                            }
                            Foreach($Net in $Networks){
                                $MerkaiInfo += [PSCustomObject]@{
                                    org_id = $Org.id
                                    org_name = $Org.name
                                    network_id = $Net.id
                                    network_name = $Net.name
                                    api_dashboard_enabled = $Org.api.enabled
                                }
                            }
                        }
                        Else{
                            Write-Host "Skipping Network Info check for ($($Org.name)) since dashboard api access is disabled for that org." -ForegroundColor Yellow
                            Continue
                        }
                    }
                    Else{
                        $MerkaiInfo += [PSCustomObject]@{
                            org_id = $Org.id
                            org_name = $Org.name
                            network_id = "N/A"
                            network_name = "N/A"
                            api_dashboard_enabled = $Org.api.enabled
                        }
                    }
                }
                Return $MerkaiInfo
            }

            #Validate CollectorId
            If(!$CollectorId){
                #If no collector id specified, choose first available collector
                $CollectorId = (Get-LMCollector | Select -First 1).id
                If(!$CollectorId){
                    Write-Host "Unable to find a collector, ensure a collector has been deployed and try again" -ForegroundColor Red
                    Return
                }
            }
            Else{
                $Collector = Get-LMCollector -Id $CollectorId
                If(!$Collector){
                    Write-Host "Unable to find collector with the specific id: $CollectorId, ensure the collector id is correct and try again" -ForegroundColor Red
                    Return
                }
            }

            #Check if Meraki device group exists, if not create it
            $MerakiDeviceGroup = Get-LMDeviceGroupGroups -Id $MerakiFolderParentGroupId | Where-Object {$_.Name -eq $MerakiRootFolderName}
            If(!$MerakiDeviceGroup){
                $GroupProps = @{
                    "meraki.api.key" = $MerakiAPIToken
                }
                Write-Host "[INFO]: Creating new Meraki device group : $MerakiRootFolderName"
                $MerakiDeviceGroup = New-LMDeviceGroup -Name $MerakiRootFolderName -ParentGroupId $MerakiFolderParentGroupId -Properties $GroupProps
                If(!$MerakiDeviceGroup){
                    Write-Host "Failed to create Meraki device group" -ForegroundColor Red
                    Return
                }
            }
            Else{
                Write-Host "[INFO]: Existing Meraki device group ($MerakiRootFolderName), already added to LogicMonitor, skipping creation" -ForegroundColor Gray
            }

            #Meraki API Endpoint
            $MerakiAPIEndpoint = "https://api.meraki.com/api/v1"

            Try{
                $Orgs = Invoke-RestMethod -Uri "https://api.meraki.com/api/v1/organizations" -Headers @{"X-Cisco-Meraki-API-Key"=$MerakiAPIToken}
            }
            Catch [Exception] {
                If($_.Exception.Response.StatusCode.value__ -eq "401"){
                    Write-Host "Unathorized request, check API token and try again." -ForegroundColor Red
                    Return
                }
                Else{
                    Write-Host $_.Exception.Response.StatusDescription -ForegroundColor Red
                }
            }
            Foreach($Org in $Orgs){
                $OrgId = $Org.id
                $OrgName = $Org.name -replace "[/\\\*\<\>\,\`\(\)\|\']" , ""
                $Networks = @()
                $Devices = @()

                If ($AllowedOrgIds -ne $null) {
                    If (!$AllowedOrgIds.Contains($OrgId)) {
                        Write-Host "[INFO]: Skipping Meraki OrgId ($OrgId), not found in AllowedOrgIds list" -ForegroundColor Gray
                        Continue
                    }
                }

                If ($Org.api.enabled -eq $false) {
                    Write-Host "[INFO]: Skipping Meraki OrgId ($OrgId), dashbaord API access not enabled" -ForegroundColor Gray
                    Continue
                }

                Try {
                    $Networks = Invoke-RestMethod -Uri "https://api.meraki.com/api/v1/organizations/$OrgId/networks" -Headers @{"X-Cisco-Meraki-API-Key"=$MerakiAPIToken}
                    $Devices = Invoke-RestMethod -Uri "https://api.meraki.com/api/v1/organizations/$OrgId/devices" -Headers @{"X-Cisco-Meraki-API-Key"=$MerakiAPIToken}
                }
                Catch [Exception] {
                    Write-Host $_.Exception.Response.StatusDescription -ForegroundColor Red
                    Continue
                }

                #Only add orgs if they have networks.
                If (($Networks | Measure-Object).Count -gt 0) {
                    #Create Dynamic Group for Meraki Org if it does not exists, adding in required SNMP info and props for proper collection
                    $OrgGroup = Get-LMDeviceGroupGroups -Id $MerakiDeviceGroup.Id | Where-Object {$_.Name -eq "$OrgName"}
                    If($OrgGroup){
                        Write-Host "[INFO]: Existing Meraki Org device group ($OrgName) already added to LogicMonitor, skipping creation" -ForegroundColor Gray
                    }
                    Else{
                        #Get SNMP Creds for group properties
                        $SNMPInfo = Invoke-RestMethod -Uri "https://api.meraki.com/api/v1/organizations/$OrgId/snmp" -Headers @{"X-Cisco-Meraki-API-Key"=$MerakiAPIToken}
                        If($SNMPInfo.v3Enabled){
                            $OrgGroupProps = @{
                                "snmp.auth" = $(If($SNMPInfo.v3AuthMode -like "SHA*"){"SHA"}Else{"MD5"})
                                "snmp.authToken" = "changeme"
                                "snmp.priv" = $(If($SNMPInfo.v3PrivMode -like "AES*"){"AES"}Else{"DES"})
                                "snmp.privToken" = "changeme"
                                "snmp.port" = $SNMPInfo.port
                                "snmp.security" = $SNMPInfo.v3User
                                "snmp.version" = "v3"
                                "system.categories" = "NoHTTPS,NoPing"
                            }
                            $OrgGroup = New-LMDeviceGroup -Name $OrgName -Properties $OrgGroupProps -ParentGroupId $MerakiDeviceGroup.id -AppliesTo "meraki.org.id == `"$OrgId`""
                            If(!$OrgGroup){
                                Write-Host "Failed to create Meraki org device group ($OrgName)" -ForegroundColor Red
                                Continue
                            }
                            Else{
                                Write-Host "[INFO]: Created Meraki Org device group ($OrgName). This Org is using SNMPv3 to poll network devices, you must update device group properties (snmp.authToken & snmp.privToken) with the correct values." -ForegroundColor Yellow
                            }
                        }
                        ElseIf($SNMPInfo.v2cEnabled){
                            $OrgGroupProps = @{
                                "snmp.port" = $SNMPInfo.port
                                "snmp.community" = $SNMPInfo.v2CommunityString
                                "snmp.version" = "v2c"
                                "system.categories" = "NoHTTPS,NoPing"
                            }
                            $OrgGroup = New-LMDeviceGroup -Name $OrgName -Properties $OrgGroupProps -ParentGroupId $MerakiDeviceGroup.id -AppliesTo "meraki.org.id == `"$OrgId`""
                            If(!$OrgGroup){
                                Write-Host "Failed to create Meraki org device group ($OrgName)" -ForegroundColor Red
                                Continue
                            }
                            Else{
                                Write-Host "[INFO]: Created Meraki Org device group ($OrgName). This Org is using SNMPv2c to poll network devices, an appropriate snmp.community ($($SNMPInfo.v2CommunityString)) property has been set for this device group."
                            }
                        }
                        
                    }

                    $OrgHostName = "$($OrgName.Replace(' ','')).invalid"
                    $OrgDisplayName = "Meraki Org: $OrgName"

                    $OrgProps = @{
                        "meraki.org.name" = $OrgName
                        "meraki.org.id" = $OrgId
                    }

                    #Check if org device already exists
                    $ExistingOrgDevice = Get-LMDevice -Name $OrgHostName
                    If($ExistingOrgDevice){
                        Write-Host "[INFO]: Existing Meraki Org device ($OrgDisplayName) already added to LogicMonitor, skipping creation" -ForegroundColor Gray
                    }
                    ELse{                        
                        Write-Host "[INFO]: Creating new Meraki Org device: $OrgDisplayName"
                        $OrgDevice = New-LMDevice -DisplayName $OrgDisplayName -Name $OrgHostName -Properties $OrgProps -PreferredCollectorId $CollectorId
                    }
                }

                Foreach($Network in $Networks) {

                    $NetworkId = $Network.id

                    If ($AllowedNetworkIds -ne $null) {
                        If (!$AllowedNetworkIds.Contains($NetworkId)) {
                            Write-Host "[INFO]: Skipping Meraki NetworkId ($NetworkId), not found in AllowedNetworkIds list" -ForegroundColor Gray
                            Continue
                        }
                    }
            
                    #Check if this network has any devices and avoid reporting deviceless networks.
                    $NetworkDevices  = $Devices.networkId.Contains($Network.id)
                    If (($NetworkDevices | Measure-Object).Count -eq 0) {
                        Write-Host "[INFO]:$($Network.name) does not contain any devices, skipping processing" -ForegroundColor Gray
                        Continue
                    }
            
                    $NetworkName = $Network.name -replace "[/\\\*\<\>\,\`\(\)\|\']" , ""
                    $NetworkTags = $Network.tags
                    $NetworkType = $Network.productTypes
                    $NetworkHostName = "$($OrgName.Replace(' ','')).$($NetworkName.Replace(' ','')).invalid"
                    $NetworkDisplayName = "Meraki Network: $NetworkName"

                    $NetworkProps = @{
                        "meraki.org.name" = $OrgName
                        "meraki.org.id" = $OrgId
                        "meraki.network.id" = $NetworkId
                        "meraki.network.name" = $NetworkName
                        "meraki.network.tags" = $(If(!$NetworkTags){"[]"}Else{$NetworkTags -join ","})
                        "meraki.network.type" = $NetworkType -Join ", "
                    }

                    #Check if network device already exists
                    $ExistingNetworkDevice = Get-LMDevice -Name $NetworkHostName
                    If($ExistingNetworkDevice){
                        Write-Host "[INFO]: Existing Meraki Network device ($NetworkDisplayName) already added to LogicMonitor, skipping creation" -ForegroundColor Gray
                    }
                    ELse{
                        Write-Host "[INFO]: Creating new Meraki Network device: $NetworkDisplayName"
                        $NetworkDevice = New-LMDevice -DisplayName $NetworkDisplayName -Name $NetworkHostName -Properties $NetworkProps -PreferredCollectorId $CollectorId                
                    }

                }
            }

            #Check if api device already exists
            $ExistingAPIDevice = Get-LMDevice -Name "api.meraki.com"
            If($ExistingAPIDevice){
                Write-Host "[INFO]: Existing Meraki API device (api.meraki.com) already added to LogicMonitor, skipping creation" -ForegroundColor Gray
            }
            ELse{ 
                Write-Host "[INFO]: Creating new Meraki API device: api.meraki.com"
                $APIDevice = New-LMDevice -DisplayName "api.meraki.com" -Name "api.meraki.com" -PreferredCollectorId $CollectorId -HostGroupIds @($($MerakiDeviceGroup.id))
            }
            Return

        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
