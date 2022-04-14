Function New-LMPushMetricDataPoint {

    [CmdletBinding()]
    Param (
        
        [Array]$DataPointsArray,

        [Parameter(Mandatory)]
        [Hashtable]$DataPoints, # hashtable with datapoint name and value

        [ValidateSet("counter", "derive", "gauge")]
        [String]$DataPointType = "gauge",

        [ValidateSet("min", "max", "avg","sum","none","percentile")]
        [String]$DataPointAggregationType = "none",

        [ValidateRange(0, 100)]
        [Int]$PercentileValue
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Add each datapoint to new datapoint array
        Foreach($Hash in $DataPoints.GetEnumerator()){
            $DataPointsArray += $DataPointsObject.PsObject.Properties | ForEach-Object {
                [PSCustomObject]@{
                    dataPointName = $($Hash.Name)
                    dataPointType = $DataPointType
                    dataPointAggregationType = $DataPointAggregationType
                    percentileValue = $PercentileValue
                    values = @{$(Get-Date -UFormat %s)=$($Hash.Value)}
                }
            }
        }
            
        Return $DataPointsArray
    }
    Else {
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
