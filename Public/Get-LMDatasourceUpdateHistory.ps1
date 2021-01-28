Function Get-LMDatasourceUpdateHistory
{

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [String]$Filter,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        If($Name){
            If($Name -Match "\*"){
                Write-Host "Wildcard values not supported for datsource name." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMDatasource -Name $Name | Select-Object -First 1 ).Id
            If(!$Id){
                Write-Host "Unable to find datasource with name: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }

        If($DisplayName){
            If($DisplayName -Match "\*"){
                Write-Host "Wildcard values not supported for datsource name." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMDatasource -DisplayName $DisplayName | Select-Object -First 1 ).Id
            If(!$Id){
                Write-Host "Unable to find datasource with display name: $DisplayName, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/setting/datasources/$Id/updatereasons"

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
                $QueryParams += "&filter=$Filter"
            }

            Try{
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Request = Invoke-WebRequest -Uri $Uri -Method "GET" -Headers $Headers
                $Response = $Request.Content | ConvertFrom-Json

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
            Catch [Microsoft.PowerShell.Commands.HttpResponseException] {
                $HttpException = ($PSItem.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                $HttpStatusCode = $PSItem.Exception.Response.StatusCode.value__
                Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
                $Done = $true
            }
            Catch{
                $LMError = $PSItem.ToString()
                Write-Error "Failed to execute web request: $LMError"
                $Done = $true
            }
        }
        Return $Results
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
