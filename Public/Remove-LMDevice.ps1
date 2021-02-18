Function Remove-LMDevice
{

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id',ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$Name,

        [boolean]$HardDelete = $false

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If($global:LMAuth.Valid){

            #Lookup Id if supplying username
            If($Name){
                If($Name -Match "\*"){
                    Write-Host "Wildcard values not supported for device name." -ForegroundColor Yellow
                    return
                }
                $Id = (Get-LMDevice -Name $Name | Select-Object -First 1 ).Id
                If(!$Id){
                    Write-Host "Unable to find device: $Name, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }
            
            #Build header and uri
            $ResourcePath = "/device/devices/$Id"
    
            $QueryParams = "?deleteHard=$HardDelete"
    
            #Loop through requests 
            Try{
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers
                Write-Host "Successfully removed id ($Id)" -ForegroundColor Green
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
        Else{
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
