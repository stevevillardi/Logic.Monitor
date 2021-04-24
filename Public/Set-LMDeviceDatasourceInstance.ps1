Function Set-LMDeviceDatasourceInstance {

    [CmdletBinding()]
    Param (
        [String]$DisplayName,
        
        [String]$WildValue,

        [String]$WildValue2,

        [String]$Description,

        [Hashtable]$Properties,

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$DisableAlerting,

        [String]$InstanceGroupId,

        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [String]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$Name

    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

        #Lookup Device Id
        If ($Name) {
            If ($Name -Match "\*") {
                Write-Host "Wildcard values not supported for device names." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMDeviceDataSourceList -Name $Name | Select-Object -First 1 ).Id
            If (!$Id) {
                Write-Host "Unable to find assocaited host device: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }

        #Lookup DatasourceId
        If ($DatasourceName -or $DatasourceId) {
            If ($DatasourceName -Match "\*") {
                Write-Host "Wildcard values not supported for datasource names." -ForegroundColor Yellow
                return
            }
            $HdsId = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId } | Select-Object -First 1).Id
            If (!$HdsId) {
                Write-Host "Unable to find assocaited host datasource: $DatasourceId$DatasourceName, please check spelling and try again. Datasource must have an applicable appliesTo associating the datasource to the device" -ForegroundColor Yellow
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

        #Loop through requests 
        $Done = $false
        While (!$Done) {
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

                $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data

                Return $Response
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
    }
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
