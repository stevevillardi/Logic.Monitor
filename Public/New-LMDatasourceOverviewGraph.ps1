<#
.SYNOPSIS
Creates a new datasource overview graph in LogicMonitor.

.DESCRIPTION
The New-LMDatasourceOverviewGraph function creates a new datasource overview graph in LogicMonitor. It requires the user to be logged in and have valid API credentials.

.PARAMETER RawObject
The raw object representing the graph configuration. This object will be converted to JSON and sent as the request body. Use Get-LMDatasourceOverviewGraph to get the raw object representing a graph configuration.

.PARAMETER DatasourceId
The ID of the datasource for which the overview graph is being created. This parameter is mandatory when using the 'dsId' parameter set.

.PARAMETER DatasourceName
The name of the datasource for which the overview graph is being created. This parameter is mandatory when using the 'dsName' parameter set.

.EXAMPLE
New-LMDatasourceOverviewGraph -RawObject $graphConfig -DatasourceId 12345

.EXAMPLE
New-LMDatasourceOverviewGraph -RawObject $graphConfig -DatasourceName "My Datasource"
#>
Function New-LMDatasourceOverviewGraph {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        $RawObject,

        [Parameter(Mandatory,ParameterSetName = 'dsId')]
        $DatasourceId,

        [Parameter(Mandatory,ParameterSetName = 'dsName')]
        $DatasourceName

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If($DataSourceName){
            $LookupResult = (Get-LMDatasource -Name $DataSourceName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DataSourceName) {
                Return
            }
            $DatasourceId = $LookupResult
        }

        #Build header and uri
        $ResourcePath = "/setting/datasources/$DatasourceId/ographs"

        Try {
            $Data = ($RawObject | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DatasourceGraph" )
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
