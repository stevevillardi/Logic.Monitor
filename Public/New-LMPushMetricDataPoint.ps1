Function New-LMPushMetricDataPoint {

    [CmdletBinding()]
    Param (
        
        [Array]$DataPointsArray,

        [Parameter(Mandatory)]
        [PSCustomObject]$DataPoints, # object with datapoint name and value

        [ValidateSet("counter", "derive", "gauge")]
        [String]$DataPointType = "gauge",

        [ValidateSet("min", "max", "avg","sum","none","percentile")]
        [String]$DataPointAggregationType = "none",

        [ValidateRange(0, 100)]
        [Int]$PercentileValue
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Add new datapoint to new datapoint array
        Foreach ($DataPoint in $DataPoints.PsObject.Properties){

            $DataPointsArray += [PSCustomObject]@{
                dataPointName = $($DataPoint.Name)
                dataPointType = $DataPointType
                dataPointAggregationType = $DataPointAggregationType
                percentileValue = $PercentileValue
                values = @{$(Get-Date -UFormat %s)=$($DataPoint.Value)}
            }
        }

        Return $DataPointsArray
    }
    Else {
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
