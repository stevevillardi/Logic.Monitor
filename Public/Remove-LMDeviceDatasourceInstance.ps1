Function Remove-LMDeviceDatasourceInstance {

    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Int]$DeviceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [String]$DeviceName,

        [Parameter(ValueFromPipelineByPropertyName)]
        [String]$WildValue = $null

    )

    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Device Id
            If ($DeviceName) {
                $LookupResult = (Get-LMDevice -Name $DeviceName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                    return
                }
                $DeviceId = $LookupResult
            }

            #Lookup DatasourceId
            If ($DatasourceName -or $DatasourceId) {
                $LookupResult = (Get-LMDeviceDataSourceList -Id $DeviceId | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId } ).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                    return
                }
                $HdsId = $LookupResult
            }

            #Lookup Wildcard Id
            $InstanceId = (Get-LMDeviceDataSourceInstance -DeviceId $DeviceId -DatasourceId $DatasourceId | Where-Object { $_.wildValue -eq $WildValue } | Select-Object -First 1).Id
            If (!$InstanceId) {
                Write-Error "Unable to find assocaited datasource instance with wildcard value: $WildValue, please check spelling and try again. Datasource must have an applicable appliesTo associating the datasource to the device"
                return
            }
            
            #Build header and uri
            $ResourcePath = "/device/devices/$DeviceId/devicedatasources/$HdsId/instances/$InstanceId"

            If($PSItem){
                $Message = "DeviceDisplayName: $($PSItem.deviceDisplayName) | DatasourceName: $($PSItem.name) | WildValue: $($PSItem.wildValue)"
            }
            ElseIf($DatasourceName -and $DeviceName){
                $Message = "DeviceName: $DeviceName | DatasourceName: $DatasourceName | WildValue: $WildValue"
            }
            Else{
                $Message = "DeviceId: $DeviceId | DatasourceId: $DatasourceId | WildValue: $WildValue"
            }

            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove Device Datasource Instance")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    $Result = [PSCustomObject]@{
                        InstanceId = $InstanceId
                        Message = "Successfully removed ($Message)"
                    }
                    
                    Return $Result
                }
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
    End{}
}
