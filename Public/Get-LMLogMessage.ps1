Function Get-LMLogMessage {

    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param (
        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Query')]
        [String]$Query,

        [ValidateSet("15min", "30min", "1hour", "3hour", "6hour", "12hour", "24hour", "3day", "7day", "1month", "custom")]
        [String]$Range = "15min",

        [String[]]$GroupIds,

        [String[]]$DeviceIds,

        [String[]]$GroupIdsWithSubs,

        [Int]$BatchSize = 300
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/log/anomalies/log"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Convert to epoch, if not set use defaults
        $CurrentTime = Get-Date
        Switch ($Range) {
            "15min" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddMinutes(-15))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "30min" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddMinutes(-30))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "1hour" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-1))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "3hour" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-3))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "6hour" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-6))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "12hour" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddHours(-12))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "24hour" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-1))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "3day" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-3))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "7day" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-7))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "1month" {
                $StartTime = ([DateTimeOffset]$($CurrentTime.AddDays(-30))).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($CurrentTime)).ToUnixTimeMilliseconds()
            }
            "custom" {
                $StartTime = ([DateTimeOffset]$($StartDate)).ToUnixTimeMilliseconds()
                $EndTime = ([DateTimeOffset]$($EndDate)).ToUnixTimeMilliseconds()
            }
        }

        #Loop through requests 
        While (!$Done) {
            #Build query params

            Switch ($PSCmdlet.ParameterSetName) {
                "Default" { $QueryParams = "?startTime=$StartTime&endTime=$EndTime&size=$BatchSize&range=$Range&advancedSearch=false" }
                "Query" { $QueryParams = "?startTime=$StartTime&endTime=$EndTime&q=$Query&size=$BatchSize&range=$Range&advancedSearch=false" }
            }

            If ($GroupIds) {
                $QueryParams += "&groups=$($GroupIds -join ",")"
            }
            If ($DeviceIds) {
                $QueryParams += "&devices=$($DeviceIds -join ",")"
            }
            If ($GroupIdsWithSubs) {
                $QueryParams += "&groupsIncludeAll=$($GroupIdsWithSubs -join ",")"
            }

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers

                [Int]$Total = $Response.Total
                [Int]$Count += ($Response.Items | Measure-Object).Count
                $Results += $Response.Items
                If ($Count -ge $Total -and $Total -ge 0) {
                    $Done = $true
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }

        # Return $Results
        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
