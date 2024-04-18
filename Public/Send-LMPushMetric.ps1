<#
.SYNOPSIS
Sends a push metric to LogicMonitor.

.DESCRIPTION
The Send-LMPushMetric function sends a push metric to LogicMonitor. It allows you to create a new resource or update an existing resource with the specified metric data.

.PARAMETER NewResourceHostName
Specifies the hostname of the new resource to be created. This parameter is required if you want to create a new resource.

.PARAMETER NewResourceDescription
Specifies the description of the new resource to be created. This parameter is required if you want to create a new resource.

.PARAMETER ResourceIds
Specifies the resource IDs to use for resource mapping. This parameter is mandatory.

.PARAMETER ResourceProperties
Specifies the properties of the resources to be updated. This parameter is optional.

.PARAMETER DatasourceId
Specifies the ID of the datasource. This parameter is required if the datasource name is not specified.

.PARAMETER DatasourceName
Specifies the name of the datasource. This parameter is required if the datasource ID is not specified.

.PARAMETER DatasourceDisplayName
Specifies the display name of the datasource. This parameter is optional and defaults to the datasource name if not specified.

.PARAMETER DatasourceGroup
Specifies the group of the datasource. This parameter is optional and defaults to "PushModules" if not specified.

.PARAMETER Instances
Specifies the instances of the resources to be updated. This parameter is mandatory. The instances should be the results of the New-LMPushMetricInstance function.

.EXAMPLE
Send-LMPushMetric -NewResourceHostName "NewResource" -NewResourceDescription "New Resource Description" -ResourceIds @{"system.deviceId"="12345"} -ResourceProperties @{"Property1"="Value1"; "Property2"="Value2"} -DatasourceId "123" -Instances $Instances

This example sends a push metric to LogicMonitor by creating a new resource with the specified hostname and description. It updates the resource properties and associates it with the specified datasource ID. The metric data is sent for the specified instances.

.NOTES
This function requires a valid API authentication. Make sure you are logged in before running any commands using Connect-LMAccount.
#>
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
        [System.Collections.Generic.List[object]]$Instances

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
                    dataSource              = ($DatasourceName -replace '[#\\;=]', '_')
                    dataSourceDisplayName   = ($DatasourceDisplayName -replace '[#\\;=]', '_')
                    dataSourceGroup         = $DatasourceGroup
                    instances               = $Instances

                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and $_ -ne "instances") { $Data.Remove($_) } }
                $Data = ($Data | ConvertTo-Json -Depth 10)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath + $QueryParams
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

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
