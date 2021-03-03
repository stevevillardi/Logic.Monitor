Function Remove-LMDeviceDatasourceInstance
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$Id,

        [Parameter(Mandatory,ParameterSetName = 'Id')]
        [String]$Name,

        [String]$DatasourceName,
        
        [String]$DatasourceId,

        [Parameter(Mandatory)]
        [String]$WildValue

    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        #Lookup Device Id
        If($Name){
            If($Name -Match "\*"){
                Write-Host "Wildcard values not supported for device names." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMDevice -Name $Name | Select-Object -First 1 ).Id
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

        #Lookup Wildcard Id
        $InstanceId = (Get-LMDeviceDataSourceInstance -Id $Id -HdsId $HdsId | Where-Object {$_.wildValue -eq $WildValue} | Select-Object -First 1).Id
        If(!$InstanceId){
            Write-Host "Unable to find assocaited datasource instance with wildcard value: $WildValue, please check spelling and try again. Datasource must have an applicable appliesTo associating the datasource to the device" -ForegroundColor Yellow
            return
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$InstanceId"

        #Loop through requests 
        Try{

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers

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
