<#
.SYNOPSIS
Creates a new datasource graph in LogicMonitor.

.DESCRIPTION
The New-LMDatasourceGraph function is used to create a new datasource graph in LogicMonitor. It requires the user to be logged in and have valid API credentials.

.PARAMETER RawObject
Specifies the raw object representing the graph configuration. This object will be converted to JSON format before sending the request to LogicMonitor. Use Get-LMDatasourceGraph to get the raw object representing a graph configuration.

.PARAMETER DatasourceId
Specifies the ID of the datasource to which the graph will be associated. This parameter is mandatory when using the 'dsId' parameter set.

.PARAMETER DatasourceName
Specifies the name of the datasource to which the graph will be associated. This parameter is mandatory when using the 'dsName' parameter set.

.EXAMPLE
New-LMDatasourceGraph -RawObject $graphConfig -DatasourceId 123

.EXAMPLE
New-LMDatasourceGraph -RawObject $graphConfig -DatasourceName "My Datasource"
#>

Function New-LMDatasourceGraph {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        $RawObject,

        [Parameter(Mandatory, ParameterSetName = 'dsId')]
        $DatasourceId,

        [Parameter(Mandatory, ParameterSetName = 'dsName')]
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
        $ResourcePath = "/setting/datasources/$DatasourceId/graphs"

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
