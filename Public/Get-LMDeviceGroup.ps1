<#
.SYNOPSIS
Get device group info from a connected LM portal

.DESCRIPTION
Get device group info from a connected LM portal

.PARAMETER Id
The device group id for a device group in LM.

.PARAMETER Name
The name value for a device group in LM. This value accepts wildcard input such as "* - Servers"

.PARAMETER Filter
A hashtable of additional filter properties to include with request. All properties are treated as if using the equals ":" operator. When using multiple filters they are combined as AND conditions.

An example Filter to get devices with alerting enabled and where the parent group id equals 1:
    @{parentId=1;disableAlerting=$false}

.PARAMETER BatchSize
The return size for each request, this value if not specified defaults to 1000. If a result would return 1001 and items, two requests would be made to return the full set.

.EXAMPLE
Get all device groups:
    Get-LMDeviceGroup

Get specific device group:
    Get-LMDeviceGroup -Id 1
    Get-LMDeviceGroup -Name "Locations"

Get multiple device groups using wildcards:
    Get-LMDeviceGroup -Name "* - Servers"

Get device groups using a custom filter:
    Get-LMDeviceGroup -Filter "parentId -eq '1' -and disableAlerting -eq '$false'"

.NOTES
Consult the LM API docs for a list of allowed fields when using filter parameter as all fields are not available for use with filtering.
#>
Function Get-LMDeviceGroup {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id',ValueFromPipeline)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/device/groups"

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
                        Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
            Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.DeviceGroup" )
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End{}
}
