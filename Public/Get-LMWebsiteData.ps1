Function Get-LMWebsiteData
{

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$Name,

        [Datetime]$StartDate,

        [Datetime]$EndDate
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        #Lookup Id if supplying username
        If($Name){
            If($Name -Match "\*"){
                Write-Host "Wildcard values not supported for website name." -ForegroundColor Yellow
                return
            }
            $Website = Get-LMwebsite -Name $Name | Select-Object -First 1 
            $Id = $Website.Id
            $Checkpoint = $Website.Checkpoints.Id[0]
            If(!$Id -or !$Checkpoint){
                Write-Host "Unable to find website: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        Else {
            $Checkpoint = (Get-LMwebsite -Id $Id | Select-Object -First 1 )
            If(!$Checkpoint){
                Write-Host "Unable to find checkpoint for website id: $Id, please check spelling and try again." -ForegroundColor Yellow
                return
            }
            Else{
                $Checkpoint = $Checkpoint.Checkpoints.Id[0]
            }
        }
        
        #Build header and uri
        $ResourcePath = "/website/websites/$Id/checkpoints/$Checkpoint/data"

        #Convert to epoch, if not set use defaults
        If(!$StartDate){
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddMinutes(-1)).ToUnixTimeSeconds()
        }
        Else{
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        If(!$EndDate){
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        Else{
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        #Build query params
        $QueryParams = "?size=$BatchSize&start=$StartDate&end=$EndDate"

        Try{
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers
            Return $Response
        
        }
        Catch [Microsoft.PowerShell.Commands.HttpResponseException] {
            $HttpException = ($PSItem.ErrorDetails.Message | ConvertFrom-Json).errorMessage
            $HttpStatusCode = $PSItem.Exception.Response.StatusCode.value__
            Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
        }
        Catch{
            $LMError = $PSItem.ToString()
            Write-Error "Failed to execute web request: $LMError"
        }
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
