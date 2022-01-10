Function Get-LMAlert {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Id')]
        [String]$Id,

        [ValidateSet("*", "Warning", "Error", "Critical")]
        [String]$Severity = "*",

        [ValidateSet("*", "WebsiteAlert", "DataSourceAlert", "EventSourceAlert")]
        [String]$Type = "*",

        [Boolean]$ClearedAlerts = $false,

        [Parameter(ParameterSetName = 'Filter')]
        [Hashtable]$Filter,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/alert/alerts"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()
        $QueryLimit = 10000 #API limit to how many results can be returned

        #Convert to epoch, if not set use defaults
        If (!$StartDate) {
            [int]$StartDate = 0
        }
        Else {
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        If (!$EndDate) {
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        Else {
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        #Loop through requests 
        While (!$Done) {
            #Build query params

            Switch ($PSCmdlet.ParameterSetName) {
                "Id" { $resourcePath += "/$Id" }
                "Range" { $QueryParams = "?filter=startEpoch>:`"$StartDate`",startEpoch<:`"$EndDate`",rule:`"$Severity`",type:`"$Type`",cleared:`"$ClearedAlerts`"&size=$BatchSize&offset=$Count&sort=+resourceId" }
                "All" { $QueryParams = "?filter=rule:`"$Severity`",type:`"$Type`",cleared:`"$ClearedAlerts`"&size=$BatchSize&offset=$Count&sort=+resourceId" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+resourceId"
                }
            }
            Try {
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers

                #Stop looping if single device, no need to continue
                If ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Alert" )
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $QueryLimit) {
                        $Done = $true
                        Write-LMHost "Reached $QueryLimit record query limitation for this endpoint" -ForegroundColor Yellow
                    }
                    ElseIf ($Count -ge $Total -and $Total -ge 0) {
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

        # Return $Results
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Alert" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
