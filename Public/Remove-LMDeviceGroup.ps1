Function Remove-LMDeviceGroup
{

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id',ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$Name,

        [Boolean]$DeleteHostsandChildren = $false,

        [boolean]$HardDelete = $false

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If($global:LMAuth.Valid){

            #Lookup Id if supplying username
            If($Name){
                If($Name -Match "\*"){
                    Write-Host "Wildcard values not supported for device group name." -ForegroundColor Yellow
                    return
                }
                $Id = (Get-LMDeviceGroup -Name $Name | Select-Object -First 1 ).Id
                If(!$Id){
                    Write-Host "Unable to find device group: $Name, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }
            
            #Build header and uri
            $ResourcePath = "/device/groups/$Id"

            $QueryParams = "?deleteChildren=$DeleteHostsandChildren&deleteHard=$HardDelete"

            #Loop through requests 
            Try{
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers
                $StatusCode = $Response.StatusCode

                If($StatusCode -eq "200"){
                    Write-Host "Successfully removed id ($Id) - Status Code: $StatusCode" -ForegroundColor Green
                }
                Else{
                    Write-Error "Failed to removed id ($Id) - Status Code: $StatusCode"
                }
            }
            Catch [Exception] {
                Switch($PSItem.Exception.GetType().FullName){
                    {"System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException"} {
                        $HttpException = ($PSItem.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                        $HttpStatusCode = $PSItem.Exception.Response.StatusCode.value__
                        Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
                    }
                    default {
                        $LMError = $PSItem.ToString()
                        Write-Error "Failed to execute web request: $LMError"
                    }
                }
            }
        }
        Else{
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
