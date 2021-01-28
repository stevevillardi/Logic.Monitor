Function New-LMAlertAck
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String[]]$Ids,
        [Parameter(Mandatory)]
        [String]$Note
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){
        
        #Build header and uri
        $ResourcePath = "/alerts/ack"

        #Loop through requests 
        Try{
            $Data = @{
                notes  = $Note
                allIds = @()
            }

            Foreach($Id in $Ids){
                $Data.allIds += @{model="alerts";id=$Id}
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data -Version 4
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Request = Invoke-WebRequest -Uri $Uri -Method "POST" -Headers $Headers -Body $Data
            $Response = $Request.Content | ConvertFrom-Json

            If($Response.status -eq 200){
                Write-Host "Successfully acknowledged alert id(s): $Ids" -ForegroundColor Green
            }
            Else{
                $ResponseErrors = Get-LMv4Error -InputObject $Response
                Foreach($Err in $ResponseErrors){
                    Write-Error $Err
                }
            }
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
