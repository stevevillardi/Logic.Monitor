<#
.SYNOPSIS
Exports a specified logicmodule

.DESCRIPTION
Exports logic module for backup/import into another portal

.PARAMETER LogicModuleId
Id of the logic module you are looking to export

.PARAMETER LogicModuleName
Name of the logic module you are looking to export, used as an alternative to LogicModuleId

.PARAMETER Type
Type of logic module to export

.PARAMETER DownloadPath
Path to export the logic module to, defaults to current directory if not specified

.EXAMPLE
Export-LMLogicModule -LogicModuleId 1907 -Type "eventsources"

.EXAMPLE
Export-LMLogicModule -LogicModuleName "SNMP_Network_Interfaces" -Type "datasources"

.NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.

.INPUTS
None. You cannot pipe objects to this command.

.LINK
Module repo: https://github.com/stevevillardi/Logic.Monitor

.LINK
PSGallery: https://www.powershellgallery.com/packages/Logic.Monitor
#>
Function Export-LMLogicModule {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$LogicModuleId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$LogicModuleName,

        [Parameter(Mandatory)]
        [ValidateSet("datasources", "propertyrules", "eventsources", "topologysources", "configsources")]
        [String]$Type,

        [String]$DownloadPath = (Get-Location).Path
    )

    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

        $LogicModuleInfo = @()
        $QueryParams = ""

        If ($LogicModuleName) {
            Switch ($Type) {
                "datasources" {
                    $LogicModuleInfo = Get-LMDataSource -Name $LogicModuleName
                    $DownloadPath += "\$($LogicModuleInfo.name).xml"
                    $QueryParams = "?format=xml&v=3"
                }
                "propertyrules" {
                    #Not implemented yet
                    $LogicModuleInfo = Get-LMPropertysource -Name $LogicModuleName
                    $DownloadPath += "\$($LogicModuleInfo.name).json"
                    $QueryParams = "?format=file&v=3"
                }
                "eventsources" {
                    $LogicModuleInfo = Get-LMEventSource -Name $LogicModuleName
                    $DownloadPath += "\$($LogicModuleInfo.name).xml"
                    $QueryParams = "?format=xml&v=3"
                }
                "topologysources" {
                    $LogicModuleInfo = Get-LMTopologySource -Name $LogicModuleName
                    $DownloadPath += "\$($LogicModuleInfo.name).json"
                    $QueryParams = "?format=file&v=3"
                }
                "configsources" {
                    $LogicModuleInfo = Get-LMConfigSource -Name $LogicModuleName
                    $DownloadPath += "\$($LogicModuleInfo.name).xml"
                    $QueryParams = "?format=xml&v=3"
                }
            }
            #Verify our query only returned one result
            If (Test-LookupResult -Result $LogicModuleInfo.Id -LookupString $LogicModuleName) {
                return
            }
            $LogicModuleId = $LogicModuleInfo.Id
        }
        Else {
            Switch ($Type) {
                "datasources" {
                    $LogicModuleInfo = Get-LMDatasource -Id $LogicModuleId
                    $DownloadPath += "\$($LogicModuleInfo.name).xml"
                    $QueryParams = "?format=xml&v=3"
                }
                "propertyrules" {
                    #Not implemented yet
                    $LogicModuleInfo = Get-LMPropertysource -Id $LogicModuleId
                    $DownloadPath += "\$($LogicModuleInfo.name).json"
                    $QueryParams = "?format=file&v=3"
                }
                "eventsources" {
                    $LogicModuleInfo = Get-LMEventSource -Id $LogicModuleId
                    $DownloadPath += "\$($LogicModuleInfo.name).xml"
                    $QueryParams = "?format=xml&v=3"
                }
                "topologysources" {
                    $LogicModuleInfo = Get-LMTopologySource -Id $LogicModuleId
                    $DownloadPath += "\$($LogicModuleInfo.name).json"
                    $QueryParams = "?format=file&v=3"
                }
                "configsources" {
                    $LogicModuleInfo = Get-LMConfigSource -Id $LogicModuleId
                    $DownloadPath += "\$($LogicModuleInfo.name).xml"
                    $QueryParams = "?format=xml&v=3"
                }
            }
        }

        
        #Build header and uri
        $ResourcePath = "/setting/$Type/$LogicModuleId"
        
        Try {
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers -OutFile $DownloadPath
        
            Return
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
    }
    Else {
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
