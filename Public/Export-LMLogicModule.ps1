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

    [CmdletBinding(DefaultParameterSetName = "Id")]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [Int]$LogicModuleId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$LogicModuleName,

        [Parameter(Mandatory)]
        [ValidateSet("datasources", "propertyrules", "eventsources", "topologysources", "configsources")]
        [String]$Type,

        [String]$DownloadPath = (Get-Location).Path
    )
    Begin{

    }
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            $LogicModuleInfo = @()
            $QueryParams = ""
            $ExportPath = ""

            If ($LogicModuleName) {
                Switch ($Type) {
                    "datasources" {
                        $LogicModuleInfo = Get-LMDataSource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "propertyrules" {
                        #Not implemented yet
                        $LogicModuleInfo = Get-LMPropertysource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "eventsources" {
                        $LogicModuleInfo = Get-LMEventSource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "topologysources" {
                        $LogicModuleInfo = Get-LMTopologySource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "configsources" {
                        $LogicModuleInfo = Get-LMConfigSource -Name $LogicModuleName
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
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
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "propertyrules" {
                        #Not implemented yet
                        $LogicModuleInfo = Get-LMPropertysource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "eventsources" {
                        $LogicModuleInfo = Get-LMEventSource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                    "topologysources" {
                        $LogicModuleInfo = Get-LMTopologySource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).json"
                        $QueryParams = "?format=file&v=3"
                    }
                    "configsources" {
                        $LogicModuleInfo = Get-LMConfigSource -Id $LogicModuleId
                        $ExportPath = $DownloadPath + "\$($LogicModuleInfo.name).xml"
                        $QueryParams = "?format=xml&v=3"
                    }
                }
            }

            
            #Build header and uri
            $ResourcePath = "/setting/$Type/$LogicModuleId"
            
            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1] -OutFile $ExportPath

                Return "Successfully downloaded LogicModule id ($LogicModuleId) of type $Type"
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
    End{}
}
