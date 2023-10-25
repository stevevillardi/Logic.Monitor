Function New-LMPushMetricDataPoint {

    [CmdletBinding()]
    Param (
        
        [System.Collections.Generic.List[object]]$DataPointsArray,

        [Parameter(Mandatory)]
        [System.Collections.Generic.List[object]]$DataPoints, # object with datapoint name and value

        [ValidateSet("counter", "derive", "gauge")]
        [String]$DataPointType = "gauge",

        [ValidateSet("min", "max", "avg","sum","none","percentile")]
        [String]$DataPointAggregationType = "none",

        [ValidateRange(0, 100)]
        [Int]$PercentileValue
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        If(!$DataPointsArray){
            $DataPointsArray = [System.Collections.Generic.List[object]]::New()
        }
        
        #Add each datapoint to new datapoint array
        Foreach($Datapoint in $DataPoints){
            $DataPointsArray.Add([PSCustomObject]@{
                dataPointName               = $Datapoint.Name
                dataPointType               = $DataPointType
                dataPointDescription        = ($Datapoint.Description -replace '“|”','')
                dataPointAggregationType    = $DataPointAggregationType
                percentileValue             = $PercentileValue
                values                      = @{$((Get-Date -UFormat %s).Split(".")[0])=$Datapoint.Value}
            })
        }
            
        Return $DataPointsArray
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
