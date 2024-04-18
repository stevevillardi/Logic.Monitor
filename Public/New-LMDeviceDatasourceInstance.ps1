<#
.SYNOPSIS
Creates a new instance of a LogicMonitor device datasource.

.DESCRIPTION
The New-LMDeviceDatasourceInstance function creates a new instance of a LogicMonitor device datasource. It requires valid API credentials and a logged-in session.

.PARAMETER DisplayName
The display name of the new instance.

.PARAMETER WildValue
The wild value of the new instance.

.PARAMETER WildValue2
The second wild value of the new instance.

.PARAMETER Description
The description of the new instance.

.PARAMETER Properties
A hashtable of custom properties for the new instance.

.PARAMETER StopMonitoring
Specifies whether to stop monitoring the new instance. Default is $false.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the new instance. Default is $false.

.PARAMETER InstanceGroupId
The ID of the instance group to which the new instance belongs.

.PARAMETER DatasourceName
The name of the datasource associated with the new instance. Mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
The ID of the datasource associated with the new instance. Mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
The ID of the host device associated with the new instance. Mandatory when using the 'Id-dsId' or 'Id-dsName' parameter sets.

.PARAMETER Name
The name of the host device associated with the new instance. Mandatory when using the 'Name-dsName' or 'Name-dsId' parameter sets.

.EXAMPLE
New-LMDeviceDatasourceInstance -DisplayName "Instance 1" -WildValue "Value 1" -Description "This is a new instance" -DatasourceName "DataSource 1" -Name "Host Device 1"

This example creates a new instance of a LogicMonitor device datasource with the specified display name, wild value, description, datasource name, and host device name.

.NOTES
Please ensure you are logged in before running any commands. Use Connect-LMAccount to login and try again.
#>
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
