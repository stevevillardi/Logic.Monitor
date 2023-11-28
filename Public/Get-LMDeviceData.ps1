Function Get-LMDeviceData {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceId')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceName')]
        [Int]$DeviceId,
    
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceName')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceId')]
        [String]$DeviceName,

        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsName-deviceName-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceId-instanceId')]
        [Parameter(Mandatory, ParameterSetName = 'dsId-deviceName-instanceId')]
        [Int]$InstanceId,
    
        [Parameter(ParameterSetName = 'dsName-deviceId-instanceName')]
        [Parameter(ParameterSetName = 'dsName-deviceName-instanceName')]
        [Parameter(ParameterSetName = 'dsId-deviceName-instanceName')]
        [Parameter(ParameterSetName = 'dsId-deviceId-instanceName')]
        [String]$InstanceName,

        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [Object]$Filter,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Convert to epoch, if not set use defaults
        If ($StartDate) {
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        If (!$EndDate -and $StartDate) {
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }

        If ($EndDate -and $StartDate) {
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

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
            $LookupResult = (Get-LMDeviceDataSourceList -Id $DeviceId | Where-Object { $_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId }).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DatasourceName) {
                return
            }
            $HdsId = $LookupResult
        }

        #Lookup InstanceId
        If ($InstanceName) {

            $LookupResult = (Get-LMDeviceDatasourceInstance -DeviceId $DeviceId -DatasourceId $DatasourceId | Where-Object { $_.displayName -eq $InstanceName -or $_.name -like "*$InstanceName" -or $_.name -eq "$InstanceName"}).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $InstanceName) {
                return
            }
            $InstanceId = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$DeviceId/devicedatasources/$HdsId/instances/$InstanceId/data"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"
            
            If ($Filter) {
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
            }

            #Add time range filter if provided data ranges
            If($StartDate -and $EndDate){
                $QueryParams = $QueryParams + "&start=$StartDate&end=$EndDate"
            }
            
            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                    
                
                
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
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
        #Convert results into readable format for consumption
        If($Response){
            $DatapointResults = @($null) * ($Response.values | Measure-Object).Count
            for ($v = 0 ; $v -lt ($Response.values | Measure-Object).Count ; $v++){
                    $DatapointResults[$v] = [PSCustomObject]@{}
                    $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name "TimestampEpoch" -Value $Response.time[$v]

                    $TimestampConverted = (([System.DateTimeOffset]::FromUnixTimeMilliseconds($Response.time[$v])).DateTime).ToString()
                    $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name "TimestampUTC" -Value $TimestampConverted

                for ($dp = 0 ; $dp -lt ($Response.dataPoints | Measure-Object).Count; $dp++){
                    $DatapointResults[$v] | Add-Member -MemberType NoteProperty -Name $Response.dataPoints[$dp] -Value $Response.values[$v][$dp]
                }
            }
            Return $DatapointResults
        }
        Else{
            Return
        }

    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
