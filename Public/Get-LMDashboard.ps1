<#
.SYNOPSIS
Retrieves LogicMonitor dashboards based on specified parameters.

.DESCRIPTION
The Get-LMDashboard function retrieves LogicMonitor dashboards based on the specified parameters. It supports filtering by ID, name, group ID, group name, subgroups, and custom filters. The function uses the LogicMonitor REST API to make the requests.

.PARAMETER Id
Specifies the ID of the dashboard to retrieve.

.PARAMETER Name
Specifies the name of the dashboard to retrieve.

.PARAMETER GroupId
Specifies the ID of the group to filter the dashboards by.

.PARAMETER GroupName
Specifies the name of the group to filter the dashboards by.

.PARAMETER GroupPathSearchString
Specifies a search string to filter the dashboards by group path.

.PARAMETER Filter
Specifies a custom filter to apply to the dashboards. The filter should be an object that contains the filter properties.

.PARAMETER BatchSize
Specifies the number of dashboards to retrieve in each request. The default value is 1000.

.EXAMPLE
Get-LMDashboard -Id 123
Retrieves the dashboard with the specified ID.

.EXAMPLE
Get-LMDashboard -Name "My Dashboard"
Retrieves the dashboard with the specified name.

.EXAMPLE
Get-LMDashboard -GroupId 456
Retrieves the dashboards that belong to the group with the specified ID.

.EXAMPLE
Get-LMDashboard -GroupName "My Group"
Retrieves the dashboards that belong to the group with the specified name.

.EXAMPLE
Get-LMDashboard -GroupPathSearchString "Subgroup"
Retrieves the dashboards that belong to subgroups matching the specified search string.

.EXAMPLE
Get-LMDashboard -Filter @{Property1 = "Value1"; Property2 = "Value2"}
Retrieves the dashboards that match the specified custom filter.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this function.
#>
Function Get-LMDashboard {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'GroupId')]
        [String]$GroupId,

        [Parameter(ParameterSetName = 'GroupName')]
        [String]$GroupName,

        [Parameter(ParameterSetName = 'SubGroups')]
        [String]$GroupPathSearchString,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
    )

    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/dashboard/dashboards"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While (!$Done) {
            #Build query params
            Switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id" }
                "Id" { $resourcePath += "/$Id" }
                "GroupId" { $QueryParams = "?filter=groupId:`"$GroupId`"&size=$BatchSize&offset=$Count&sort=+id" }
                "GroupName" { $QueryParams = "?filter=groupName:`"$GroupName`"&size=$BatchSize&offset=$Count&sort=+id" }
                "SubGroups" { $QueryParams = "?filter=groupFullPath~`"$GroupPathSearchString`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Name" { $QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
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
                    Return $Response
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Dashboard" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Dashboard" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
