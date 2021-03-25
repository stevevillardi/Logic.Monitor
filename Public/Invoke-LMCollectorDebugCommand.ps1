Function Invoke-LMCollectorDebugCommand {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$Command,

        [Boolean]$IncludeResult = $false
    )

    #Check if we are logged in and have valid api creds
    Begin{}
    Process{
        If($global:LMAuth.Valid){

            #Lookup device name
            If($Name){
                If($Name -Match "\*"){
                    Write-Host "Wildcard values not supported for collector names." -ForegroundColor Yellow
                    return
                }
                $Id = (Get-LMCollector -Name $Name | Select-Object -First 1 ).Id
                If(!$Id){
                    Write-Host "Unable to find collector: $Name, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }
            
            #Build header and uri
            $ResourcePath = "/debug"

            #Build query params
            $QueryParams = "?collectorId=$Id"

            #Construct Body
            $Data = @{
                cmdline = $Command
            }

            $Data = ($Data | ConvertTo-Json)

            Try{

                $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data
                If($IncludeResult){
                    $CommandCompleted = $false
                    While(!$CommandCompleted){
                        $CommandResult = Get-LMCollectorDebugResult -SessionId $Response.sessionId -Id $Id
                        If($CommandResult.errorMessage -eq "Agent has fetched the task, waiting for response") {
                            Write-Host "Agent has fetched the task, waiting for response..." -ForegroundColor green
                            Start-Sleep -Seconds 5
                        }
                        Else {
                            $CommandCompleted = $false
                            Return $CommandResult.output
                        }
                    }
                }
                Else{
                    Write-Host "Submitted debug command task ($Command) for device id: $($Response.sessionId). Use Get-LMCollectorDebugResult to retrieve response or resubmit request with -IncludeResult" -ForegroundColor green
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
            }
            Return
        }
        Else{
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}