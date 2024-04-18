<#
.SYNOPSIS
Retrieves LogicMonitor alerts based on specified parameters.

.DESCRIPTION
The Get-LMAlert function retrieves LogicMonitor alerts based on the specified parameters. It supports filtering alerts by start and end dates, severity, type, cleared status, and custom columns. The function makes API requests to the LogicMonitor platform and returns the retrieved alerts.

.PARAMETER StartDate
Specifies the start date for filtering alerts. Only alerts that occurred after this date will be retrieved.

.PARAMETER EndDate
Specifies the end date for filtering alerts. Only alerts that occurred before this date will be retrieved.

.PARAMETER Id
Specifies the ID of a specific alert to retrieve.

.PARAMETER Severity
Specifies the severity level of alerts to retrieve. Valid values are "*", "Warning", "Error", and "Critical". The default value is "*".

.PARAMETER Type
Specifies the type of alerts to retrieve. Valid values are "*", "websiteAlert", "dataSourceAlert", "eventSourceAlert", and "logAlert". The default value is "*".

.PARAMETER ClearedAlerts
Specifies whether to retrieve cleared alerts. If set to $true, cleared alerts will be included in the results. If set to $false, only active alerts will be included. The default value is $false.

.PARAMETER Filter
Specifies a custom filter object to further refine the alerts to retrieve.

.PARAMETER CustomColumns
Specifies an array of custom columns to include in the retrieved alerts.

.PARAMETER BatchSize
Specifies the number of alerts to retrieve per API request. The default value is 1000.

.PARAMETER Sort
Specifies the sorting order of the retrieved alerts. The default value is "resourceId".

.EXAMPLE
Get-LMAlert -StartDate (Get-Date).AddDays(-7) -EndDate (Get-Date) -Severity "Error" -Type "websiteAlert" -ClearedAlerts $false
Retrieves all alerts that occurred within the last 7 days, have a severity level of "Error", are of type "websiteAlert", and are not cleared.

.EXAMPLE
Get-LMAlert -Id "12345" -CustomColumns "Column1", "Column2"
Retrieves a specific alert with the ID "12345" and includes the custom columns "Column1" and "Column2" in the result.

.NOTES
This function requires a valid API authentication session. Use the Connect-LMAccount function to log in before running this command.
#>
Function Get-LMAlert {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$StartDate,

        [Parameter(ParameterSetName = 'Range')]
        [Datetime]$EndDate,

        [Parameter(Mandatory,ParameterSetName = 'Id')]
        [String]$Id,

        [ValidateSet("*", "Warning", "Error", "Critical")]
        [String]$Severity = "*",

        [ValidateSet("*", "websiteAlert", "dataSourceAlert", "eventSourceAlert","logAlert")]
        [String]$Type = "*",

        [Boolean]$ClearedAlerts = $false,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'Id')]
        [String[]]$CustomColumns,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000,

        [String]$Sort = "resourceId"
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
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
                "Id" { 
                    $resourcePath += "/$Id" 
                
                    #Check if we need to add customColumns
                    If($CustomColumns){
                        $FormatedColumns = @()
                        Foreach($Column in $CustomColumns){
                            $FormatedColumns += [System.Web.HTTPUtility]::UrlEncode($Column)
                        }

                        If($QueryParams){
                            $QueryParams += "&customColumns=$($FormatedColumns -join ",")"
                        }
                        Else{
                            $QueryParams = "?customColumns=$($FormatedColumns -join",")"
                        }
                    }
                }
                "Range" { $QueryParams = "?filter=startEpoch>:`"$StartDate`",startEpoch<:`"$EndDate`",rule:`"$Severity`",type:`"$Type`",cleared:`"$ClearedAlerts`"&size=$BatchSize&offset=$Count&sort=+resourceId" }
                "All" { $QueryParams = "?filter=rule:`"$Severity`",type:`"$Type`",cleared:`"$ClearedAlerts`"&size=$BatchSize&offset=$Count&sort=$Sort" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=$Sort"
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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Alert" )
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

        # Return $Results
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Alert" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
