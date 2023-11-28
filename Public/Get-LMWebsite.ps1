<#
.SYNOPSIS
Get website info from a connected LM portal

.DESCRIPTION
Get website info from a connected LM portal

.PARAMETER Id
The website id for a website in LM.

.PARAMETER Name
The name value for a website in LM. This value accepts wildcard input such as "ServiceNow - *"

.PARAMETER Type
The type of websites to return. Possible values are: Webcheck or PingCheck

.PARAMETER Filter
A hashtable of additional filter properties to include with request. All properties are treated as if using the equals ":" operator. When using multiple filters they are combined as AND conditions.

An example Filter to get websites with type Webcheck that are internal:
    @{type="webcheck";isInternal=$true}

.PARAMETER BatchSize
The return size for each request, this value if not specified defaults to 1000. If a result would return 1001 and items, two requests would be made to return the full set.

.EXAMPLE
Get all websites:
    Get-LMWebsite

Get specific website:
    Get-LMWebsite -Id 1
    Get-LMWebsite -Name "LogicMonitor"

Get multiple websites using wildcards:
    Get-LMWebsite -Name "ServiceNow - *"

Get websites using a custom filter:
    Get-LMWebsite -Filter @{type="webcheck";isInternal=$true}

.NOTES
Consult the LM API docs for a list of allowed fields when using filter parameter as all fields are not available for use with filtering.
#>
Function Get-LMWebsite {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Type')]
        [ValidateSet("Webcheck", "PingCheck")]
        [String]$Type,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/website/websites"

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
                "Type" { $QueryParams = "?filter=type:`"$Type`"&size=$BatchSize&offset=$Count&sort=+id" }
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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Website" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Website" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
