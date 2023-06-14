Function New-LMDeviceDatasourceInstance {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$DisplayName,
        
        [Parameter(Mandatory)]
        [String]$WildValue,

        [String]$WildValue2,

        [String]$Description,

        [Hashtable]$Properties,

        [Boolean]$StopMonitoring = $false,

        [Boolean]$DisableAlerting = $false,

        [String]$InstanceGroupId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Nullable[Int]]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Int]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$Name

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup Device Id
        If ($Name) {
            If ($Name -Match "\*") {
                Write-Error "Wildcard values not supported for device names."
                return
            }
            $Id = (Get-LMDevice -Name $Name | Select-Object -First 1 ).Id
            If (!$Id) {
                Write-Error "Unable to find assocaited host device: $Name, please check spelling and try again."
                return
            }
        }

        #Lookup DatasourceId
        If ($DatasourceName -or $DatasourceId) {
            If ($DatasourceName -Match "\*") {
                Write-Error "Wildcard values not supported for datasource names."
                return
            }
            $HdsId = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId } | Select-Object -First 1).Id
            If (!$HdsId) {
                Write-Error "Unable to find assocaited host datasource: $DatasourceId$DatasourceName, please check spelling and try again. Datasource must have an applicable appliesTo associating the datasource to the device"
                return
            }
        }



        #Build custom props hashtable
        $customProperties = @()
        If ($Properties) {
            Foreach ($Key in $Properties.Keys) {
                $customProperties += @{name = $Key; value = $Properties[$Key] }
            }
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances"

        Try {
            $Data = @{
                displayName      = $DisplayName
                description      = $Description
                wildValue        = $WildValue
                wildValue2       = $WildValue2
                stopMonitoring   = $StopMonitoring
                disableAlerting  = $DisableAlerting
                customProperties = $customProperties
                groupId          = $InstanceGroupId
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

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
