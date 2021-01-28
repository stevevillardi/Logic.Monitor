Function Get-LMDevice
{

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [String]$Filter,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){
        
        #Build header and uri
        $ResourcePath = "/device/devices"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While(!$Done){
            #Build query params
            Switch($PSCmdlet.ParameterSetName){
                "All" {$QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"}
                "Id" {$resourcePath += "/$Id"}
                "DisplayName" {$QueryParams = "?filter=displayName:`"$DisplayName`"&size=$BatchSize&offset=$Count&sort=+id"}
                "Name" {$QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id"}
                "Filter" {$QueryParams = "?filter=$Filter&size=$BatchSize&offset=$Count&sort=+id"}
            }
            Try{
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Request = Invoke-WebRequest -Uri $Uri -Method "GET" -Headers $Headers
                $Response = $Request.Content | ConvertFrom-Json

                #Stop looping if single device, no need to continue
                If($PSCmdlet.ParameterSetName -eq "Id"){
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
