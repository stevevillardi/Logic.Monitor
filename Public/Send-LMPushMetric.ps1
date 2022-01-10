Function Send-LMPushMetric {
    
    [CmdletBinding()]
    Param (

        [Parameter(Mandatory, ParameterSetName = 'Create-DatasourceId')]
        [Parameter(Mandatory, ParameterSetName = 'Create-DatasourceName')]
        [String]$ResourceName,
        
        [Parameter(ParameterSetName = 'Create-DatasourceId')]
        [Parameter(ParameterSetName = 'Create-DatasourceName')]
        [String]$ResourceDescription,
        
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
        [String[]]$Instances,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [String]$InstanceDisplayName, #Optional defaults to InstanceName,

        [Hashtable]$InstanceProperties,

        [Parameter(Mandatory)]
        [String]$DatapointName,

        [String]$DatapointDescription, #Optional defaults to datapointName

        [ValidateSet("min", "max", "non", "avg","sum", "none")]
        [String]$DatapointAggregationType = "none",

        [Hashtable]$Values,

        [Switch]$CreateResourceIfNotFound

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($global:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }

            $QueryParams = $null
            If($CreateResourceIfNotFound){
                $QueryParams = "?create=true"
            }
                    
            #Build header and uri
            $ResourcePath = "/metric/ingest"

            Try {
                $Data = @{
                    name                      = $Name
                    displayName               = $DisplayName
                    description               = $Description
                    disableAlerting           = $DisableAlerting
                    enableNetflow             = $EnableNetFlow
                    customProperties          = $customProperties
                    preferredCollectorId      = $PreferredCollectorId
                    preferredCollectorGroupId = $PreferredCollectorGroupId
                    link                      = $Link
                    netflowCollectorGroupId   = $NetflowCollectorGroupId
                    netflowCollectorId        = $NetflowCollectorId
                    hostGroupIds              = $HostGroupIds -join ","
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

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
            Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
