<#
.SYNOPSIS
Exports a topology map to a standalone HTML file. 

.DESCRIPTION
Exports a topology map to a standalone HTML file.

.PARAMETER Id
Id of the topology map you want to export

.PARAMETER Name
Name of the topology map you are looking to export, used as an alternative to Id

.PARAMETER IncludeUndiscoveredDevices
Include undiscovered devices in topology export

.PARAMETER IncludeDataTable
Include a data table alongside the exported map

.PARAMETER EnablePhysics
Enable physics interaction on the generated topology map

.PARAMETER BackgroundImage
Add a background image to the exported topology map

.EXAMPLE
Export-LMTopologyMap -Id 12 -IncludeUndiscoveredDevices $false

.EXAMPLE
Export-LMTopologyMap Name "VMware Environment" -IncludeDataTable $true

.NOTES
Currently a beta command, topology map export is still under developement, please report any bugs you encounter while using this command.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>
Function Export-LMTopologyMap {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Boolean]$IncludeUndiscoveredDevices = $false,

        [Boolean]$IncludeDataTable = $false,

        [Boolean]$EnablePhysics = $false,

        [String]$BackgroundImage = ""
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {
        #Grab Topology Map data so we can build our HTML map
        If ($Name) {
            $TopoData = Get-LMTopologyMapData -Name $Name
            $TopoLayout = (Get-LMTopologyMap -Name $Name).layout.vertices
        }
        ElseIf ($Id) {
            $TopoData = Get-LMTopologyMapData -Id $Id
            $TopoLayout = (Get-LMTopologyMap -Id $Id).layout.vertices
        }
        
        #Loop through edges and match up to verticies to build our custom object
        $TopoObject = @()
        If ($TopoData) {
            foreach ($edge in $TopoData.edges) {
                $vToIndex = $TopoData.vertices.id.IndexOf($edge.to)
                $vFromIndex = $TopoData.vertices.id.IndexOf($edge.from)
                #We found a match in our vertices list so we continue building our object
                If ($vToIndex -ne -1 -and $vFromIndex -ne -1) {
                    $fromLayoutIndex = $TopoLayout.id.IndexOf($edge.from)
                    $toLayoutIndex = $TopoLayout.id.IndexOf($edge.to)
                    $TopoObject += [PSCustomObject]@{
                        fromId   = $TopoData.vertices[$vFromIndex].id
                        fromName = $TopoData.vertices[$vFromIndex].LMResources[0].name
                        fromType = $TopoData.vertices[$vFromIndex].type
                        fromX    = [Int][Math]::Round([Math]::Ceiling($TopoLayout[$fromLayoutIndex].x)) * .75
                        fromY    = [Int][Math]::Round([Math]::Ceiling($TopoLayout[$fromLayoutIndex].y)) * .75
                        toId     = $TopoData.vertices[$vToIndex].id
                        toName   = $TopoData.vertices[$vToIndex].LMResources[0].name
                        toType   = $TopoData.vertices[$vToIndex].type
                        toX      = [Int][Math]::Round([Math]::Ceiling($TopoLayout[$toLayoutIndex].x)) * .75
                        toY      = [Int][Math]::Round([Math]::Ceiling($TopoLayout[$toLayoutIndex].y)) * .75
                        edgeType = $edge.type
                    }
                }
            }

            If ($IncludeUndiscoveredDevices) {
                $TopoNodeGroups = $TopoObject | Group-Object fromId
            }
            Else {
                $TopoNodeGroups = $TopoObject | Where-Object { $_.fromType -ne "undiscovered" -and $_.toType -ne "undiscovered" } | Group-Object fromId
            }

            $NodeIcons = [PSCustomObject]@{
                HyperVisor        = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/HyperVisor-focus.svg'
                HyperVisorCluster = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/HyperVisorCluster-focus.svg'
                Switch            = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Switch-focus.svg'
                Undiscovered      = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Device-focus.svg'
                Unknown           = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Device-focus.svg'
                NotMonitored      = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/notmonitored-focus.svg'
                Cluster           = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Cluster-focus.svg'
                Firewall          = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Firewall-focus.svg'
                PhysicalServer    = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/PhysicalServer-focus.svg'
                VirtualMachine    = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/VirtualMachine-focus.svg'
                Service           = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Service-focus.svg'
                Pod               = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Pod-focus.svg'
                Container         = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/Container-focus.svg'
                VMDatastore       = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/VMDatastore-focus.svg'
                VirtualDisk       = 'https://static-prod.logicmonitor.com/sbui148-1/commons/images/icons/use-for-topology/VirtualDisk-focus.svg'
            }

            New-HTML -TitleText 'LogicMonitor TopologyMap'  -FilePath $PSScriptRoot\Example-LM.html {
                New-HTMLSection -HeaderText "LogicMonitor TopologyMap $Id$Name" -CanCollapse {
                    New-HTMLPanel {
                        New-HTMLDiagram -Height "900px" {
                            New-DiagramOptionsPhysics -Enabled $EnablePhysics
                            New-DiagramOptionsInteraction -Hover $true
                            New-DiagramOptionsLayout -RandomSeed 500
                            New-DiagramOptionsLinks -ArrowsToEnabled $true -Color BlueViolet -ArrowsToType arrow -ArrowsFromEnabled $false
                            New-DiagramOptionsNodes -BorderWidth 1 -FontColor Black -Size 20 -FontMulti true
                            Foreach ($group in $TopoNodeGroups) {
                                Foreach ($to in $group.Group) {

                                    New-DiagramNode -Id $to.toId -Label $to.toName -Image $(If ($NodeIcons.$($to.toType)) { $NodeIcons.$($to.toType) }Else { $NodeIcons.Unknown }) -X $to.toX -Y $to.toY -FixedX $useCoordinatesFromLM -FixedY $useCoordinatesFromLM
                                    #Write-Host "Id:$($to.toId) | Label: $($to.toName)"
                                }
                                New-DiagramNode -Id $group.Group[0].fromId -Label $group.Group[0].fromName -To $($group.Group.toId -Join ",").Split(",") -Image $(If ($NodeIcons.$($group.Group[0].fromType)) { $NodeIcons.$($group.Group[0].fromType) }Else { $NodeIcons.Unknown }) -X $group.Group[0].fromX -Y $group.Group[0].fromY -FixedX $useCoordinatesFromLM -FixedY $useCoordinatesFromLM
                                #Write-Host "Id:$($group.Group[0].fromId) | Label: $($group.Group[0].fromName) | To: $($group.Group.toId -Join ",")"
                            }
                        } -BackGroundImage $BackgroundImage
                    }
                    If ($IncludeDataTable) {
                        New-HTMLPanel {
                            New-HTMLTable -DataTable $(If (!$IncludeUndiscoveredDevices) { $TopoObject | Where-Object { $_.fromType -ne "undiscovered" -and $_.toType -ne "undiscovered" } | Select-Object -ExcludeProperty fromX, fromY, toX, toY }Else { $TopoObject | Select-Object -ExcludeProperty fromX, fromY, toX, toY }) -PagingLength 30 -DefaultSortIndex 1
                        }
                    }
                }
            } -ShowHTML -Online
        }
        Else {
            Write-Host "Unable to retrieve topology data for give id/name, please check spelling and try again" -ForegroundColor Yellow
            Return
        }
    }
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}