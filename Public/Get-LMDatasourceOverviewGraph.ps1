Function Get-LMDatasourceOverviewGraph {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Id-dsName')]
        [Int]$Id,

        [Parameter(Mandatory,ParameterSetName = 'dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Filter-dsName')]
        [String]$DataSourceName,
        
        [Parameter(Mandatory,ParameterSetName = 'dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Filter-dsId')]
        [String]$DataSourceId,
        
        [Parameter(Mandatory,ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsName')]
        [String]$Name,
        
        [Parameter(Mandatory,ParameterSetName = 'Filter-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Filter-dsName')]
        [Object]$Filter,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
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

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            Switch -Wildcard ($PSCmdlet.ParameterSetName) {
                "All*" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+displayPrio" }
                "Id" { $resourcePath += "/$Id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+displayPrio" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+displayPrio"
                }
            }
            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                    
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DatasourceGraph")
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $Total) {
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DatasourceGraph")
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
