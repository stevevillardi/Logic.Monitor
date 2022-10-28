Function Get-LMDeviceConfigSourceDiff {

    [CmdletBinding(DefaultParameterSetName = 'ListDiffs')]
    Param (
        [Parameter(Mandatory)]
        [Int]$Id,

        [Parameter(Mandatory)]
        [String]$HdsId,

        [Parameter(Mandatory)]
        [String]$HdsInsId,

        [Parameter(ParameterSetName = 'ConfigId')]
        [String]$ConfigId,

        [Parameter(ParameterSetName = 'ListDiffs')]
        [Int]$BatchSize = 100

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/devicedatasources/$HdsId/instances/$HdsInsId/config"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            If($ConfigId){
                $StartEpoch = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
                $ResourcePath = $ResourcePath + "/$ConfigId"
                $QueryParams = "?deviceId=$Id&deviceDataSourceId=$HdsId&instanceId=$HdsInsId&fields=!deltaconfig&startEpoch=$StartEpoch"
            }
            Else{
                $QueryParams = "?size=$BatchSize&offset=$Count&fields=!config"
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers

                #Stop looping if single device, no need to continue
                If (![bool]$Response.psobject.Properties["total"]) {
                    $Done = $true
                    Return $Response
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $Total) {
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
