<#
.SYNOPSIS
Invokes a configuration collection task for a LogicMonitor device.

.DESCRIPTION
The Invoke-LMDeviceConfigSourceCollection function is used to schedule a configuration collection task for a LogicMonitor device. It requires the user to be logged in and have valid API credentials.

.PARAMETER DatasourceName
Specifies the name of the datasource. This parameter is mandatory when using the 'Id-dsName' or 'Name-dsName' parameter sets.

.PARAMETER DatasourceId
Specifies the ID of the datasource. This parameter is mandatory when using the 'Id-dsId' or 'Name-dsId' parameter sets.

.PARAMETER Id
Specifies the ID of the device. This parameter is mandatory when using the 'Id-dsId', 'Id-dsName', or 'Id-HdsId' parameter sets.

.PARAMETER Name
Specifies the name of the device. This parameter is mandatory when using the 'Name-dsName', 'Name-dsId', or 'Name-HdsId' parameter sets.

.PARAMETER HdsId
Specifies the ID of the host datasource. This parameter is mandatory when using the 'Id-HdsId' or 'Name-HdsId' parameter sets.

.PARAMETER InstanceId
Specifies the ID of the device instance. This parameter is mandatory.

.EXAMPLE
Invoke-LMDeviceConfigSourceCollection -Name "MyDevice" -DatasourceName "MyDatasource" -InstanceId "12345"
Schedules a configuration collection task for the device with the name "MyDevice", the datasource with the name "MyDatasource", and the instance with the ID "12345".

.EXAMPLE
Invoke-LMDeviceConfigSourceCollection -Id 123 -DatasourceId 456 -InstanceId "12345"
Schedules a configuration collection task for the device with the ID 123, the datasource with the ID 456, and the instance with the ID "12345".

.NOTES
This function requires the LogicMonitor PowerShell module to be installed.
#>
Function Invoke-LMDeviceConfigSourceCollection {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId')]
        [Int]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id-HdsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-HdsId')]
        [String]$HdsId,

        [Parameter(Mandatory)]
        [String]$InstanceId
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup Device Id
            If ($Name) {
                $LookupResult = (Get-LMDevice -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup DatasourceId
            If ($DatasourceName -or $DatasourceId) {
                $LookupResult = (Get-LMDeviceDataSourceList -Id $Id | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsId = $LookupResult
            }
                     
            #Build header and uri
            $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$InstanceId/config/configCollection"

            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1]
                
                Return "Scheduled Config collection task for device id: $Id."
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
