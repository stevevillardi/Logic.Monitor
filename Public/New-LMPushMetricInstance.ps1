Function New-LMPushMetricInstance {

    [CmdletBinding()]
    Param (
        
        [Array]$InstancesArrary,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [String]$InstanceDisplayName,

        [Hashtable]$InstanceProperties,
 
        [Parameter(Mandatory)]
        [Array]$Datapoints
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Add new instance to new instances array
        $InstancesArrary += [PSCustomObject]@{
            instanceName = $InstanceName
            instanceDisplayName = If($InstanceDisplayName){$InstanceDisplayName}Else{$InstanceName}
            instanceProperties = $InstanceProperties
            dataPoints = $Datapoints
        }

        Return $InstancesArrary
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
