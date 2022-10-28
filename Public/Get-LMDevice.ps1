<#
.SYNOPSIS
Get device info from a connected LM portal

.DESCRIPTION
Get device info from a connected LM portal

.PARAMETER Id
The device id for a device in LM.

.PARAMETER DisplayName
The display name value for a device in LM. This value can include wildcard input such as "*.example.com"

.PARAMETER Name
The name value for a device in LM. This is the fqdn/ip used when adding a device into LM. This value accepts wildcard input such as "10.10.*"

.PARAMETER Filter
A hashtable of additonal filter properties to include with request. All properies are treated as if using the equals ":" operator. When using multiple filters they are combined as AND conditions.

An example Filter to get devices with alerting enabled and where the display name contains equal.com:
    @{displayName="*.example.com";disableAlerting=$false}

.PARAMETER BatchSize
The return size for each request, this value if not specified defaults to 1000. If a result would return 1001 and items, two requests would be made to return the full set.

.EXAMPLE
Get all devices:
    Get-LMDevice

Get specific device:
    Get-LMDevice -Id 1
    Get-LMDevice -DisplayName "device.example.com"
    Get-LMDevice -Name "10.10.10.10"

Get multiple devices using wildcards:
    Get-LMDevice -DisplayName "*.example.com"
    Get-LMDevice -Name "10.10.*"

Get device/s using a custom filter:
    Get-LMDevice -Filter @{displayName="corp-*";preferredCollectorId=1}

.NOTES
Consult the LM API docs for a list of allowed fields when using filter parameter as all fields are not available for use with filtering.
#>
Function Get-LMDevice {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Hashtable]$Filter,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/device/devices"

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
                "DisplayName" { $QueryParams = "?filter=displayName:`"$DisplayName`"&size=$BatchSize&offset=$Count&sort=+id" }
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
