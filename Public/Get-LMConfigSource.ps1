<#
.SYNOPSIS
Retrieves LogicMonitor configuration sources based on specified parameters.

.DESCRIPTION
The Get-LMConfigSource function retrieves LogicMonitor configuration sources based on the specified parameters. It supports retrieving configuration sources by ID, name, or using a filter. The function uses the LogicMonitor REST API to make the requests.

.PARAMETER Id
Specifies the ID of the configuration source to retrieve. This parameter is mutually exclusive with the Name and Filter parameters.

.PARAMETER Name
Specifies the name of the configuration source to retrieve. This parameter is mutually exclusive with the Id and Filter parameters.

.PARAMETER Filter
Specifies a filter object to retrieve configuration sources based on specific criteria. This parameter is mutually exclusive with the Id and Name parameters.

.PARAMETER BatchSize
Specifies the number of configuration sources to retrieve in each batch. The default value is 1000.

.EXAMPLE
Get-LMConfigSource -Id 123
Retrieves the configuration source with the ID 123.

.EXAMPLE
Get-LMConfigSource -Name "MyConfigSource"
Retrieves the configuration source with the name "MyConfigSource".

.EXAMPLE
Get-LMConfigSource -Filter @{ Property = "Value" }
Retrieves configuration sources based on the specified filter criteria.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this function.
#>
Function Get-LMConfigSource {

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
        $ResourcePath = "/setting/configsources"

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
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Datasource")
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.Datasource")
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
