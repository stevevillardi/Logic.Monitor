Function Set-LMAPIToken
{

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id')]
        [Int]$UserId,

        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$UserName,

        [Parameter(Mandatory)]
        [Int]$APITokenId,

        [String]$Note,

        [ValidateSet("active","suspended")]
        [String]$Status

    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        #Lookup Id if supplying username
        If($Username){
            If($Username -Match "\*"){
                Write-Host "Wildcard values not supported for username." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMUser -Name $Username | Select-Object -First 1 ).Id
            If(!$Id){
                Write-Host "Unable to find username: $Username, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/setting/admins/$UserId/apitokens/$APITokenId"

        #Loop through requests 
        Try{
            $Data = @{
                note = $Note
                status = $Status
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if (-not $Data[$_]) { $Data.Remove($_) } }

            If($Status){
                $Data.status = $(If($Status -eq "active"){2}Else{1})
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data

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
