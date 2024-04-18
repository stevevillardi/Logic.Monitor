Function Set-LMDeviceDatasourceInstanceAlertSetting {

    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory, ParameterSetName = 'Id-dsName')]
        [Alias("DeviceId")]
        [Int]$Id,
    
        [Parameter(Mandatory, ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory, ParameterSetName = 'Name-dsId')]
        [Alias("DeviceName")]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$DatapointName,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [Nullable[bool]]$DisableAlerting,

        [String]$AlertExpressionNote,

        [Parameter(Mandatory)]
        [AllowEmptyString()]
        [String]$AlertExpression, #format for alert expression (01:00 02:00) > -100 timezone=America/New_York

        [Parameter(Mandatory)]
        [ValidateRange(0, 60)]
        [Int]$AlertClearTransitionInterval,

        [Parameter(Mandatory)]
        [ValidateRange(0, 60)]
        [Int]$AlertTransitionInterval,

        [Parameter(Mandatory)]
        [ValidateRange(1, 4)]
        [Int]$AlertForNoData
    )

    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
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

            #Lookup HdsiId
            If ($DatasourceName) {
                $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceName $DatasourceName -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName"}).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                    return
                }
                $HdsiId = $LookupResult
            }
            Else{
                $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceId $DatasourceId -DeviceId $Id | Where-Object { $_.name -like "*$InstanceName"}).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                    return
                }
                $HdsiId = $LookupResult
            }

            #Lookup HdsiId
            If ($DatapointName) {
                $LookupResult = (Get-LMDeviceDatasourceInstanceAlertSetting -DatasourceName $DatasourceName -Id $Id -InstanceName $InstanceName | Where-Object { $_.dataPointName -eq $DatapointName}).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                    return
                }
                $DatapointId = $LookupResult
            }
            Else{
                $LookupResult = (Get-LMDeviceDatasourceInstance -DatasourceId $DatasourceId -Id $Id -InstanceName $InstanceName | Where-Object { $_.dataPointName -eq $DatapointName}).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                    return
                }
                $DatapointId = $LookupResult
            }

            #Build header and uri
            $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsiId/alertsettings/$DatapointId"

            $Message = "Id: $Id | hostDatasourceId: $HdsId | datapointId: $DatapointId"

            Try {
                $Data = @{
                    disableAlerting      = $DisableAlerting
                    alertExprNote        = $AlertExpressionNote
                    alertExpr            = $AlertExpression
                    alertClearTransitionInterval    = $AlertClearTransitionInterval
                    alertClearInterval              = $AlertClearTransitionInterval
                    alertTransitionInterval         = $AlertTransitionInterval
                    alertForNoData                  = $AlertForNoData
                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and $_ -ne "alertExpr" -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }

                $Data = ($Data | ConvertTo-Json)
                If ($PSCmdlet.ShouldProcess($Message, "Set Device Datasource Instance Alert Setting")) { 
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AlertSetting" )
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
