<#
.SYNOPSIS
Retrieves the versions of LogicMonitor collectors available for download.

.DESCRIPTION
The Get-LMCollectorVersions function retrieves the versions of LogicMonitor collectors based on the specified parameters. It requires a valid API authentication and authorization.

.PARAMETER Filter
Specifies the filter to apply when retrieving collector versions. Only collector versions that match the specified filter will be returned.

.PARAMETER TopVersions
Indicates whether to retrieve only the top versions of collector versions.

.PARAMETER BatchSize
Specifies the number of collector versions to retrieve in each batch. The default value is 1000.

.INPUTS
None. You cannot pipe objects to Get-LMCollectorVersions.

.OUTPUTS
System.Object
Returns an object that contains the retrieved collector versions.

.EXAMPLE
Get-LMCollectorVersions -Filter "name=Collector1"

This example retrieves the collector versions that have the name "Collector1".

.EXAMPLE
Get-LMCollectorVersions -TopVersions

This example retrieves only the top versions of collector versions.

.EXAMPLE
Get-LMCollectorVersions -BatchSize 500

This example retrieves the collector versions in batches of 500.
#>
Function Get-LMCollectorVersions {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [Parameter(ParameterSetName = 'Top')]
        [Switch]$TopVersions,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/collector/collectors/versions"

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
                "Top" { $QueryParams = "?topVersions=true&size=$BatchSize&offset=$Count&sort=+id" }
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
