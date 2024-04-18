<#
.SYNOPSIS
Creates a new data point object for pushing metric data to LogicMonitor.

.DESCRIPTION
The New-LMPushMetricDataPoint function creates a new data point object that can be used to push metric data to LogicMonitor. The function accepts an array of data points, where each data point consists of a name and a value. The function also allows you to specify the data point type, aggregation type, and percentile value.

.PARAMETER DataPointsArray
An optional parameter that allows you to pass an existing array of data points. If not provided, a new array will be created.

.PARAMETER DataPoints
A mandatory parameter that accepts an array of data points. Each data point should be an object with a Name and a Value property.

.PARAMETER DataPointType
Specifies the type of the data point. Valid values are "counter", "derive", and "gauge". The default value is "gauge".

.PARAMETER DataPointAggregationType
Specifies the aggregation type of the data point. Valid values are "min", "max", "avg", "sum", "none", and "percentile". The default value is "none".

.PARAMETER PercentileValue
Specifies the percentile value for the data point. This parameter is only applicable when the DataPointAggregationType is set to "percentile". The value should be between 0 and 100.

.EXAMPLE
$datapoints = @(
    [PSCustomObject]@{
        Name = "CPUUsage"
        Value = 80
    },
    [PSCustomObject]@{
        Name = "MemoryUsage"
        Value = 60
    }
)

New-LMPushMetricDataPoint -DataPoints $datapoints -DataPointType "gauge" -DataPointAggregationType "avg"

This example creates two data points for CPU usage and memory usage, and sets the data point type to "gauge" and the aggregation type to "avg".

.NOTES
LogicMonitor API credentials must be set before using this function. Use the Connect-LMAccount function to log in and set the credentials.
#>
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
