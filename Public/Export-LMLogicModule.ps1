Function Export-LMLogicModule
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id')]
        [Int]$LogicModuleId,

        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$LogicModuleName,

        [Parameter(Mandatory)]
        [ValidateSet("datasources", "propertyrules", "eventsources", "topologysources", "configsources")]
        [String]$Type,

        [String]$DownloadPath = (Get-Location).Path
    )

    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        $LogicModuleInfo = @()
        $QueryParams = ""

        If($LogicModuleName){
            Switch($Type){
                "datasources" {
                    $LogicModuleInfo = Get-LMDatasource -Name $LogicModuleName
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
            If(Test-LookupResult -Result $LogicModuleInfo.Id -LookupString $LogicModuleName){
                return
            }
            $LogicModuleId = $LogicModuleInfo.Id
        }
        Else{
            Switch($Type){
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

        Try{
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers -OutFile $DownloadPath

        }
        Catch [Exception] {
            $Exception = $PSItem
            Switch($PSItem.Exception.GetType().FullName){
                {"System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException"} {
                    $HttpException = ($Exception.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                    $HttpStatusCode = $Exception.Exception.Response.StatusCode.value__
                    Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
                }
                default {
                    $LMError = $Exception.ToString()
                    Write-Error "Failed to execute web request: $LMError"
                }
            }
            Return
        }
        Return
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
