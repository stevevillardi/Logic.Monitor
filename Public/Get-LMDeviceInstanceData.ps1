<#
.SYNOPSIS
Retrieves data for LogicMonitor device instances.

.DESCRIPTION
The Get-LMDeviceInstanceData function retrieves data for LogicMonitor device instances based on the specified parameters.

.PARAMETER StartDate
The start date for the data retrieval. If not specified, the function uses the default value of 24 hours ago which is the max timeframe for this endpoint.

.PARAMETER EndDate
The end date for the data retrieval. If not specified, the function uses the current date and time.

.PARAMETER Ids
The array of device instance IDs for which to retrieve data. This parameter is mandatory.

.PARAMETER AggregationType
The type of aggregation to apply to the retrieved data. Valid values are "first", "last", "min", "max", "sum", "average", and "none". The default value is "none".

.PARAMETER Period
The period for the data retrieval. The default value is 1.

.EXAMPLE
Get-LMDeviceInstanceData -StartDate (Get-Date).AddHours(-7) -EndDate (Get-Date) -Ids "12345", "67890" -AggregationType "average" -Period 1
Retrieves data for the device instances with IDs "12345" and "67890" for the past 7 hours, using an average aggregation and a period of 1 day.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure to log in using Connect-LMAccount before running this command.
#>
Function Get-LMDeviceInstanceData {

    [CmdletBinding()]
    Param (
        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [Parameter(Mandatory)]
        [Alias("Id")]
        [String[]]$Ids,

        [ValidateSet("first", "last", "min", "max", "sum", "average", "none")]
        [String]$AggregationType = "none",

        [Double]$Period = 1 #Seems like the only value here is 1, so default to 1
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/device/instances/datafetch"

        #Initalize vars
        $QueryParams = ""
        $Results = @()

        #Convert to epoch, if not set use defaults
        If (!$StartDate) {
            [int]$StartDate =  ([DateTimeOffset]$(Get-Date).AddHours(-24)).ToUnixTimeSeconds()
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

        #Build query params

        $QueryParams = "?period=$Period&start=$StartDate&end=$EndDate&aggregate=$AggregationType"

        $Data = @{
            "instanceIds" = $Ids -join ","
        } | ConvertTo-Json
        
        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            $Results = $Response.Items
        }
        Catch [Exception] {
            Resolve-LMException -LMException $PSItem
        }

        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
