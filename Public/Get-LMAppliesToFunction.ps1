<#
.SYNOPSIS
Retrieves LogicMonitor AppliesTo functions based on different parameters.

.DESCRIPTION
The Get-LMAppliesToFunction function retrieves LogicMonitor AppliesTo functions based on different parameters such as Id, Name, or Filter. It uses the LogicMonitor API to make the requests and returns the results.

.PARAMETER Id
Specifies the Id of the AppliesTo function to retrieve. This parameter is mutually exclusive with the Name and Filter parameters.

.PARAMETER Name
Specifies the Name of the AppliesTo function to retrieve. This parameter is mutually exclusive with the Id and Filter parameters.

.PARAMETER Filter
Specifies a custom filter to apply when retrieving AppliesTo functions. This parameter is mutually exclusive with the Id and Name parameters. The filter should be an object that matches the filter structure expected by the LogicMonitor API.

.PARAMETER BatchSize
Specifies the number of results to retrieve per request. The default value is 1000.

.EXAMPLE
Get-LMAppliesToFunction -Id 123
Retrieves the AppliesTo function with the specified Id.

.EXAMPLE
Get-LMAppliesToFunction -Name "MyFunction"
Retrieves the AppliesTo function with the specified Name.

.EXAMPLE
Get-LMAppliesToFunction -Filter @{ Property = "Value" }
Retrieves the AppliesTo functions that match the specified custom filter.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure to log in using the Connect-LMAccount function before running any commands.

.LINK
https://www.logicmonitor.com/support/rest-api-developers-guide/

#>
Function Get-LMAppliesToFunction {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/functions"

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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AppliesToFunction" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.AppliesToFunction" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
