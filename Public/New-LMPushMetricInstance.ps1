Function New-LMPushMetricInstance {

    [CmdletBinding()]
    Param (
        
    [System.Collections.Generic.List[object]]$InstancesArrary,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [String]$InstanceDisplayName,

        [String]$InstanceDescription,

        [Hashtable]$InstanceProperties,
 
        [Parameter(Mandatory)]
        [System.Collections.Generic.List[object]]$Datapoints
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        If(!$InstancesArrary){
            $InstancesArrary = [System.Collections.Generic.List[object]]::New()
        }

        #Add new instance to new instances array
        $InstancesArrary.Add([PSCustomObject]@{
            instanceName = $InstanceName
            instanceDisplayName = If($InstanceDisplayName){$InstanceDisplayName}Else{$InstanceName}
            instanceProperties = $InstanceProperties
            instanceDescription = $InstanceDescription
            dataPoints = $Datapoints
        })

        Return $InstancesArrary
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
