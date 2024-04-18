<#
.SYNOPSIS
Retrieves LogicMonitor API tokens based on specified parameters.

.DESCRIPTION
The Get-LMAPIToken function retrieves LogicMonitor API tokens based on the specified parameters. It supports various parameter sets to filter the tokens based on different criteria such as AdminId, Id, AccessId, and Filter. The function also allows specifying the token type and batch size for pagination.

.PARAMETER AdminId
Specifies the ID of the admin for which to retrieve API tokens. This parameter is only applicable when using the 'AdminId' parameter set.

.PARAMETER Id
Specifies the ID of the API token to retrieve. This parameter is only applicable when using the 'Id' parameter set.

.PARAMETER AccessId
Specifies the access ID of the API token to retrieve. This parameter is only applicable when using the 'AccessId' parameter set.

.PARAMETER Filter
Specifies a custom filter object to retrieve API tokens based on specific criteria. This parameter is only applicable when using the 'Filter' parameter set.

.PARAMETER Type
Specifies the type of API token to retrieve. Valid values are 'LMv1', 'Bearer', or '*'. The default value is '*'.

.PARAMETER BatchSize
Specifies the number of API tokens to retrieve per batch. The default value is 1000.

.EXAMPLE
Get-LMAPIToken -AdminId 1234
Retrieves all API tokens associated with the admin ID 1234.

.EXAMPLE
Get-LMAPIToken -Id 5678
Retrieves the API token with the ID 5678.

.EXAMPLE
Get-LMAPIToken -AccessId "abc123"
Retrieves the API token with the access ID "abc123".

.EXAMPLE
Get-LMAPIToken -Filter @{ Property1 = "Value1"; Property2 = "Value2" }
Retrieves API tokens based on the specified custom filter object.

.EXAMPLE
Get-LMAPIToken -Type "Bearer" -BatchSize 500
Retrieves API tokens of type 'Bearer' with a batch size of 500.

.NOTES
This function requires a valid LogicMonitor authentication session. Make sure to log in using the Connect-LMAccount function before running this command.
#>
Function Get-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'AdminId')]
        [Int]$AdminId,

        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'AccessId')]
        [String]$AccessId,

        [Parameter(ParameterSetName = 'Filter')]
        [Object]$Filter,

        [ValidateSet("LMv1", "Bearer", "*")]
        [String]$Type = "*",

        [ValidateRange(1,1000)]
        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/admins/apitokens"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        If($Type -eq "Bearer"){
            $BearerParam = "&type=bearer"
        }

        #Loop through requests 
        While (!$Done) {
            #Build query params
            Switch ($PSCmdlet.ParameterSetName) {
                "All" { $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id$BearerParam" }
                "Id" { $QueryParams = "?filter=id:$Id&size=$BatchSize&offset=$Count&sort=+id$BearerParam" }
                "AccessId" { $QueryParams = "?filter=accessId:`"$AccessId`"&size=$BatchSize&offset=$Count&sort=+id$BearerParam" }
                "AdminId" { $resourcePath = "/setting/admins/$AdminId/apitokens$BearerParam" }
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id$BearerParam"
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
                    Return (Add-ObjectTypeInfo -InputObject $Response.items -TypeName "LogicMonitor.APIToken" )
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
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.APIToken" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
