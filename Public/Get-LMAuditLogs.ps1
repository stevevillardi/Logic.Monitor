<#
.SYNOPSIS
Retrieves audit logs from LogicMonitor.

.DESCRIPTION
The Get-LMAuditLogs function retrieves audit logs from LogicMonitor based on the specified parameters. It supports retrieving logs by ID, by date range, or by applying filters.

.PARAMETER Id
Specifies the ID of the audit log to retrieve. This parameter is mutually exclusive with the SearchString, StartDate, EndDate, and Filter parameters.

.PARAMETER SearchString
Specifies a search string to filter the audit logs. Only logs that contain the specified search string will be returned. This parameter is used in conjunction with the StartDate and EndDate parameters.

.PARAMETER StartDate
Specifies the start date of the audit logs to retrieve. Only logs that occurred on or after the specified start date will be returned. This parameter is used in conjunction with the SearchString and EndDate parameters.

.PARAMETER EndDate
Specifies the end date of the audit logs to retrieve. Only logs that occurred on or before the specified end date will be returned. This parameter is used in conjunction with the SearchString and StartDate parameters.

.PARAMETER Filter
Specifies a filter object to further refine the audit logs to retrieve. This parameter is used in conjunction with the StartDate and EndDate parameters.

.PARAMETER BatchSize
Specifies the number of audit logs to retrieve per request. The default value is 1000.

.EXAMPLE
Get-LMAuditLogs -Id "12345"
Retrieves the audit log with the specified ID.

.EXAMPLE
Get-LMAuditLogs -SearchString "login" -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date)
Retrieves audit logs that contain the search string "login" and occurred within the last 7 days.

.NOTES
This function requires a valid connection to LogicMonitor. Use Connect-LMAccount to establish a connection before running this command.
#>
Function Get-LMAuditLogs {

    [CmdletBinding(DefaultParameterSetName = 'Range')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [String]$Id,

        [Parameter(ParameterSetName = 'Range')]
        [String]$SearchString,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$EndDate,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
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
            If($PSCmdlet.ParameterSetName -ne "Id"){
                Write-LMHost "[WARN]: No start date specified, defaulting to last 30 days" -ForegroundColor Yellow
            }
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddDays(-30)).ToUnixTimeSeconds()
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
                "Range" { $QueryParams = "?filter=happenedOn%3E%3A`"$StartDate`"%2ChappenedOn%3C%3A`"$EndDate`"%2C_all~`"*$SearchString*`"&size=$BatchSize&offset=$Count&sort=+happenedOn" }
                "Id" { $resourcePath += "/$Id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+happenedOn"
                }
            }
            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                #Stop looping if single device, no need to continue
                If ($PSCmdlet.ParameterSetName -eq "Id") {
                    $Done = $true
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AuditLog" )
                }
                #Check result size and if needed loop again
                Else {
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If ($Count -ge $QueryLimit) {
                        $Done = $true
                        Write-LMHost "[WARN]: Reached $QueryLimit record query limitation for this endpoint" -ForegroundColor Yellow
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.AuditLog" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
