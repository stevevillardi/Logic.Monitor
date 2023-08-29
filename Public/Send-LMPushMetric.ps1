Function Send-LMPushMetric {
    
    [CmdletBinding()]
    Param (

        [Parameter(ParameterSetName = 'Create-DatasourceId')]
        [Parameter(ParameterSetName = 'Create-DatasourceName')]
        [String]$NewResourceHostName,
        
        [Parameter(ParameterSetName = 'Create-DatasourceId')]
        [Parameter(ParameterSetName = 'Create-DatasourceName')]
        [String]$NewResourceDescription,
        
        [Parameter(Mandatory)]
        [Hashtable]$ResourceIds,

        [Hashtable]$ResourceProperties,

        [Parameter(Mandatory, ParameterSetName = 'Create-DatasourceId')]
        [String]$DatasourceId, #Needed if Datasource name is not specified

        [Parameter(Mandatory, ParameterSetName = 'Create-DatasourceName')]
        [String]$DatasourceName,

        [String]$DatasourceDisplayName, #Optional defaults to datasourceName if not specified

        [String]$DatasourceGroup, #Optional defaults to PushModules

        [Parameter(Mandatory)]
        [Array]$Instances

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            $QueryParams = $null
            If($NewResourceHostName){
                $QueryParams = "?create=true"
            }
                    
            #Build header and uri
            $ResourcePath = "/metric/ingest"


            Try {
                $Data = @{
                    resourceName            = $NewResourceHostName
                    resourceDescription     = $NewResourceDescription
                    resourceIds             = $ResourceIds
                    resourceProperties      = $ResourceProperties
                    dataSourceId            = $DatasourceId
                    dataSource              = $DatasourceName
                    dataSourceDisplayName   = $DatasourceDisplayName
                    dataSourceGroup         = $DatasourceGroup
                    instances               = $Instances

                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json -Depth 10)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath + $QueryParams
                
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return $Response
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
    End {}
}
