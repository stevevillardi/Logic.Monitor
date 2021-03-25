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
A hashtable of additonal filter properties to include with request. All properies are treated as if using the equals ":" operator. When using multiple filters they are combined as AND conditions.

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
Function Get-LMWebsite
{

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
        [Hashtable]$Filter,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){
        
        #Build header and uri
        $ResourcePath = "/website/websites"

        #Initalize vars
        $QueryParams = ""
        $Count = 0
        $Done = $false
        $Results = @()

        #Loop through requests 
        While(!$Done){
            #Build query params
            Switch($PSCmdlet.ParameterSetName){
                "All" {$QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"}
                "Id" {$resourcePath += "/$Id"}
                "Type" {$QueryParams = "?filter=type:`"$Type`"&size=$BatchSize&offset=$Count&sort=+id"}
                "Name" {$QueryParams = "?filter=name:`"$Name`"&size=$BatchSize&offset=$Count&sort=+id"}
                "Filter" {
                    #List of allowed filter props
                    $PropList = @()
                    $ValidFilter = Format-LMFilter -Filter $Filter -PropList $PropList
                    $QueryParams = "?filter=$ValidFilter&size=$BatchSize&offset=$Count&sort=+id"
                }
            }
            Try{
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers

                #Stop looping if single device, no need to continue
                If($PSCmdlet.ParameterSetName -eq "Id"){
                    $Done = $true
                    Return $Response
                }
                #Check result size and if needed loop again
                Else{
                    [Int]$Total = $Response.Total
                    [Int]$Count += ($Response.Items | Measure-Object).Count
                    $Results += $Response.Items
                    If($Count -ge $Total){
                        $Done = $true
                    }
                }
            }
            Catch [Exception] {
                $Exception = $PSItem
                Switch ($PSItem.Exception.GetType().FullName) {
                    { "System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException" } {
                        $HttpException = ($Exception.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                        $HttpStatusCode = $Exception.Exception.Response.StatusCode.value__
                        Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
                    }
                    default {
                        $LMError = $Exception.ToString()
                        Write-Error "Failed to execute web request: $LMError"
                    }
                }
                Return
            }
        }
        Return $Results
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
