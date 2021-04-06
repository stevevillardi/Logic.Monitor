Function Get-LMAuditLogs {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [String]$Id,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Filter')]
        [Hashtable]$Filter,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/accesslogs"

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
                "All" { $QueryParams = "?filter=happenedOn%3E%3A`"$StartDate`"%2ChappenedOn%3C%3A`"$EndDate`"&size=$BatchSize&offset=$Count&sort=+happenedOn" }
                "Id" { $resourcePath += "/$Id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+happenedOn"
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
                    Return $Response
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $QueryLimit) {
                        $Done = $true
                        Write-Host "Reached $QueryLimit record query limitation for this endpoint" -ForegroundColor Yellow
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
        Return $Results
    }
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
