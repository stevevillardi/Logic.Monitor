Function New-LMAPIToken
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id')]
        [String[]]$Id,
        [Parameter(Mandatory,ParameterSetName = 'Username')]
        [String]$Username,
        [String]$Note,
        [Switch]$CreateDisabled
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        If($Username){
            If($Username -Match "\*"){
                Write-Host "Wildcard values not supported for device group name." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMUser -Name $Username | Select-Object -First 1 ).Id
            If(!$Id){
                Write-Host "Unable to find device group with name: $Username, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/setting/admins/$Id/apitokens"

        #Loop through requests 
        Try{
            $Data = @{
                note  = $Note
                status = $(If($CreateDisabled){1}Else{2})
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

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
