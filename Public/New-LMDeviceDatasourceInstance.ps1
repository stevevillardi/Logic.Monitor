Function New-LMDeviceDatasourceInstance
{

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

        [Parameter(Mandatory,ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory,ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory,ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Id-dsName')]
        [Int]$Id,
    
        [Parameter(Mandatory,ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsId')]
        [String]$Name

    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        #Lookup Device Id
        If($Name){
            If($Name -Match "\*"){
                Write-Host "Wildcard values not supported for device names." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMDeviceDataSourceList -Name $Name | Select-Object -First 1 ).Id
            If(!$Id){
                Write-Host "Unable to find assocaited host device: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }

        #Lookup DatasourceId
        If($DatasourceName -or $DatasourceId){
            If($DatasourceName -Match "\*"){
                Write-Host "Wildcard values not supported for datasource names." -ForegroundColor Yellow
                return
            }
            $HdsId = (Get-LMDeviceDataSourceList -Id $Id | Where-Object {$_.dataSourceName -eq $DatasourceName -or $_.dataSourceId -eq $DatasourceId} | Select-Object -First 1).Id
            If(!$HdsId){
                Write-Host "Unable to find assocaited host datasource: $DatasourceId$DatasourceName, please check spelling and try again. Datasource must have an applicable appliesTo associating the datasource to the device" -ForegroundColor Yellow
                return
            }
        }



        #Build custom props hashtable
        $customProperties = @()
        If($Properties){
            Foreach($Key in $Properties.Keys){
                $customProperties += @{name=$Key;value=$Properties[$Key]}
            }
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances"

        #Loop through requests 
        Try{
            $Data = @{
                displayName = $DisplayName
                description = $Description
                wildValue = $WildValue
                wildValue2 = $WildValue2
                stopMonitoring = $StopMonitoring
                disableAlerting = $DisableAlerting
                customProperties =  $customProperties
                groupId = $InstanceGroupId
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

            Return $Response
        }
        Catch [Exception] {
            $Exception = $PSItem
            Switch ($PSItem.Exception.GetType().FullName) {
                { "System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException" } {
                    $HttpException = ($Exception.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                    $HttpStatusCode = $Exception.Exception.Response.StatusCode.value__
                    Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
                }
                default {
                    $LMError = $Exception.ToString()
                    Write-Error "Failed to execute web request: $LMError"
                }
            }
            Return
        }
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
