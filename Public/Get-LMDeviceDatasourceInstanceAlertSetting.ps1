Function Get-LMDeviceDatasourceInstanceAlertSetting
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsName')]
        [String]$DatasourceName,
    
        [Parameter(Mandatory,ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsId')]
        [Int]$DatasourceId,
    
        [Parameter(Mandatory,ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Id-HdsId')]
        [Int]$Id,
    
        [Parameter(Mandatory,ParameterSetName = 'Name-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-HdsId')]
        [String]$Name,

        [Parameter(Mandatory,ParameterSetName = 'Id-HdsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-HdsId')]
        [String]$HdsId,

        [Parameter(Mandatory,ParameterSetName = 'Id-HdsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-HdsId')]
        [Parameter(Mandatory,ParameterSetName = 'Id-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsId')]
        [Parameter(Mandatory,ParameterSetName = 'Id-dsName')]
        [Parameter(Mandatory,ParameterSetName = 'Name-dsName')]
        [String]$HdsiId,

        [Hashtable]$Filter,

        [Int]$BatchSize = 1000

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
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsiId/alertsettings"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While(!$Done){
            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

            If($Filter){
                #List of allowed filter props
                $PropList = @()
                $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
            }

            Try{
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers

                #Stop looping if single device, no need to continue
                If(![bool]$Response.psobject.Properties["total"]){
                    $Done = $true
                    Return $Response
                }
                #Check result size and if needed loop again
                Else{
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If($Count -ge $Total){
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Exception = $PSItem
                Switch($PSItem.Exception.GetType().FullName){
                    {"System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException"} {
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
        Return $Results
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
