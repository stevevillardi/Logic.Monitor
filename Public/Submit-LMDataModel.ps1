
Function Submit-LMDataModel{
    [CmdletBinding()]
    Param(
        [Parameter(ValueFromPipeline,Mandatory)]
        [ValidateScript({ 
            If(Test-Json $_ -ErrorAction SilentlyContinue){$TestObject = $_ | ConvertFrom-Json -Depth 10}
            Else{ $TestObject = $_}

            $RequiredProperties= @("Datasources","Properties","DisplayName","HostName","SimulationType")
            $Members= Get-Member -InputObject $TestObject -MemberType NoteProperty
            If($Members){
                $MissingProperties= Compare-Object -ReferenceObject $Members.Name -DifferenceObject $RequiredProperties -PassThru | Where-Object {$_.SideIndicator -eq "=>"}
            }
            #Missing expected schema properties, dont continue
            If (!$MissingProperties){$True}
            Else{Throw [System.Management.Automation.ValidationMetadataException] "Missing schema properties: $($missingProperties -Join ",")"}
        })]
        [Parameter(Mandatory,ParameterSetName="Object")]
        $ModelObject,

        [Parameter(Mandatory,ParameterSetName="Json")]
        $ModelJson,

        [String]$DatasourceSuffix = "_PMv1",

        [Switch]$ForceGraphProvisioning
    )
    Begin{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Type -ne "Bearer") {
            Write-Error "Push Metrics API only supports Bearer Token auth, please re-connect using a valid bearer token."
        }
        return
    }
    Process{
        #Silently try to convert from JSON incase supplied object is loaded from a JSON file
        If($ModelJson){
            Write-Debug "Model format detected as JSON, converting to PSObject."
            $ModelObject = $ModelJson | ConvertFrom-Json -Depth 10
        }
        #Loop through models and submit for ingest
        $ModelCount = ($ModelObject.Datasources | Measure-Object).Count

        Write-LMHost "=========================================================================" -ForegroundColor White
        Write-LMHost "|                  BEGIN PROCESSING ($($ModelObject.DisplayName))                  |" -ForegroundColor White
        Write-LMHost "=========================================================================" -ForegroundColor White
        Write-LMHost "Model contains $ModelCount datasource(s) for ingest, beinging processing."
        Foreach($Model in $ModelObject.Datasources){
            $InstCount = ($Model.Instances | Measure-Object).Count
            $DpCount = ($Model.Datapoints | Measure-Object).Count
            $GCount = ($Model.Graphs | Measure-Object).Count
            $OGCount = ($Model.OverviewGraphs | Measure-Object).Count
            Write-LMHost "Model loaded for datasource $($Model.Defenition.Name) using device $($ModelObject.DisplayName) and simulation type $($ModelObject.SimulationType)."
            Write-LMHost "Model contains $InstCount instance(s), each with $DpCount datapoint(s) and $($GCount + $OGCount) graph definition(s)."

            #Loop through instances and generate instance and dp objects
            $InstanceArray = [System.Collections.Generic.List[object]]::New()
            Foreach($Instance in $Model.Instances){
                Write-Debug "Processing datapoints for instance $($Instance.Name)."
                $Datapoints = [System.Collections.Generic.List[object]]::New()
                Foreach($Datapoint in $Model.Datapoints){
                    $Value = Generate-LMData -Datapoint $Datapoint -Instance $Instance -SimulationType $ModelObject.SimulationType
                    $Datapoints.Add([PSCustomObject]@{
                        Name = $Datapoint.Name
                        Description = $Datapoint.Description
                        Value = $Value
                    })
                }
                $DatapointsArray = New-LMPushMetricDataPoint -Datapoints $Datapoints
                If($Instance.Properties){$Instance.Properties.PSObject.Properties | ForEach-Object -begin {$InstancePropertyHash=@{}} -process {$InstancePropertyHash."$($_.Name)" = $_.Value}}
                $InstanceArray.Add($(New-LMPushMetricInstance -Datapoints $DatapointsArray -InstanceName $Instance.Name -InstanceDisplayName $Instance.DisplayName -InstanceDescription $Instance.Description -InstanceProperties $InstancePropertyHash))
            }

            #Submit PushMetric to portal
            $DeviceHostName = $ModelObject.HostName
            $DeviceDisplayName = $ModelObject.DisplayName
            $DatasourceGroup =  $Model.DatasourceGroupName
            $DatasourceDisplayName = $Model.Defenition.displayName
            $DatasourceName = $Model.Defenition.Name.Replace("-","") + $DatasourceSuffix
            $ResourceIds = @{"system.hostname"=$DeviceHostName;"system.displayname"=$DeviceDisplayName}

            Write-LMHost "Submitting PushMetric to ingest."
            If($ModelObject.Properties){$ModelObject.Properties.PSObject.Properties | ForEach-Object -begin {$DevicePropertyHash=@{}} -process {$DevicePropertyHash."$($_.Name)" = $_.Value}}
            $Result = Send-LMPushMetric -Instances $InstanceArray -DatasourceGroup $DatasourceGroup -DatasourceDisplayName $DatasourceDisplayName -DatasourceName $DatasourceName -ResourceIds $ResourceIds -ResourceProperties $DevicePropertyHash -NewResourceHostName $DeviceHostName

            Write-LMHost "PushMetric submitted with status: $($Result.message)  @($($Result.timestamp))"
            #Apply graph definitions if they do not exist yet
            Write-Debug "Checking if datasource $DatasourceName has been created yet"
            $PMDatasource = Get-LMDatasource -Name $DatasourceName
            If($PMDatasource.Id){
                Write-Debug "$DatasourceName found, checking if graph defentions have been created yet."
                $PMGraphs = Get-LMDatasourceGraph -DataSourceId $PMDatasource.Id
                $PMOverviewGraphs = Get-LMDatasourceOverviewGraph -DataSourceId $PMDatasource.Id

                If((!$PMGraphs -or $ForceGraphProvisioning) -and $Model.Graphs){
                    Write-Debug "No instance graphs found or force creation specified, importing graph definitions from model."
                    Foreach($Graph in $Model.Graphs){
                        Write-Debug "Importing instance graph $($Graph.Name)."
                        #Update datapointIDs in each graph so they match the new push module
                        Foreach($Datapoint in $Graph.datapoints){
                            $DPName = $Datapoint.Name
                            $DPIndex = $PMDatasource.datapoints.name.IndexOf($DPName)
                            $DPId = $PMDatasource.datapoints[$DPIndex].id

                            $Index = $Graph.datapoints.name.IndexOf($DPName)
                            If($Index -eq -1){
                                $Graph.datapoints[$Index].dataPointId = $null
                                $Graph.datapoints[$Index].dataSourceDataPointId = $null
                            }
                            Else{
                                $Graph.datapoints[$Index].dataPointId = $DPId
                                $Graph.datapoints[$Index].dataSourceDataPointId = $DPId
                            }
                        }
                        New-LMDatasourceGraph -RawObject $Graph -DatasourceId $PMDatasource.Id | Out-Null
                    }
                }
                Else{
                    Write-Debug "Existing instance graphs found or none included with selected model, skipping importing instance graph definitions."
                }
                If((!$PMOverviewGraphs -or $ForceGraphProvisioning) -and $Model.OverviewGraphs){
                    Write-Debug "No overview graphs found or force creation specified, importing graph definitions from model."
                    Foreach($OverviewGraph in $Model.OverviewGraphs){
                        Write-Debug "Importing overview graph $($OverviewGraph.Name)."
                        #Update datapointIDs in each graph so they match the new push module
                        Foreach($Datapoint in $OverviewGraph.datapoints){
                            $DPName = $Datapoint.dataPointName
                            $DPIndex = $PMDatasource.datapoints.name.IndexOf($DPName)
                            $DPId = $PMDatasource.datapoints[$DPIndex].id

                            $Index = $OverviewGraph.datapoints.dataPointName.IndexOf($DPName)
                            If($Index -eq -1){
                                $OverviewGraph.datapoints[$Index].dataPointId = $null
                                $OverviewGraph.datapoints[$Index].dataSourceDataPointId = $null
                            }
                            Else{
                                $OverviewGraph.datapoints[$Index].dataPointId = $DPId
                                $OverviewGraph.datapoints[$Index].dataSourceDataPointId = $DPId
                            }
                        }
                        New-LMDatasourceOverviewGraph -RawObject $OverviewGraph -DatasourceId $PMDatasource.Id | Out-Null
                    }
                }
                Else{
                    Write-Debug "Existing overview graphs found or none included with selected model, skipping importing overview graph definitions."
                }
            }
            Else{
                Write-Debug "$DatasourceName not found, will recheck on next submission."
            }
        }
    }
    End{
        Write-LMHost "=========================================================================" -ForegroundColor White
        Write-LMHost "|                  END PROCESSING ($($ModelObject.DisplayName))                  |" -ForegroundColor White
        Write-LMHost "=========================================================================" -ForegroundColor White
    }
}

Function Generate-LMData {
    [CmdletBinding()]
    Param(
        $Datapoint,
        $Instance,
        $SimulationType
    )
    #If we have instance data from our model, use that instead
    If($Instance.Data){
        $FilteredData = $Instance.Data | Where-Object {$_."$($Datapoint.Name)" -ne "No Data"}
        If($FilteredData){

            $TotalDPs = ($FilteredData | Measure-Object).Count - 1
            $Variance = 5 #Introduce some variation into slected index so we dont have as many duplicate polls when the sample size is smaller than 100
            [Int]$TimeSlice = Get-Date -Format %Hmm 
            $TimePercentage = $TimeSlice/2359
            $IndexValue = [Math]::Floor($(Get-Random -Minimum $([decimal]($TotalDPs * $TimePercentage) - $Variance) -Maximum $([decimal]($TotalDPs * $TimePercentage) + $Variance)))
            If($IndexValue -ge $TotalDPs){$IndexValue = -1} #If we go out of index, set to last item
            If($IndexValue -lt 0){$IndexValue = -0} #If we go our of index set to first item
            $Value = $FilteredData[$IndexValue]."$($Datapoint.Name)"

            Write-Debug "Generated value of ($Value) for datapoint ($($Instance.Name)-$($Datapoint.Name)) using data provided with the model."
        }
        Else{
            $Value = 0
            Write-Debug "No instance data found for datapoint ($($Instance.Name)-$($Datapoint.Name)) using value of ($Value) as fallback."
        }

    }
    Else{
        Switch($SimulationType){
            "replicaiton" {
                #TODO
            }
            "8to5" {
                #TODO
            }
            default {
                $Value = Switch($Datapoint.MetricType){
                    "Rate" {
                        Get-Random -Minimum 0 -Maximum 125000
                    }
                    "Percentage" {
                        Get-Random -Minimum 0 -Maximum 100
                    }
                    "IO-Latency" {
                        Get-Random -Minimum 0 -Maximum 125000
                    }
                    "SpaceUsage" {
                        Get-Random -Minimum 0 -Maximum 322122547200
                    }
                    "Status" {
                        If($Datapoint.MinValue -and $Datapoint.MaxValue){
                            Get-Random -Minimum $Datapoint.MinValue -Maximum $Datapoint.MaxValue
                        }
                        Else{
                            Get-Random -Minimum 0 -Maximum 5
                        }
                    }
                    Default {
                        Get-Random -Minimum 0 -Maximum 1000
                    }
                }
            }
        }
        Write-Debug "Generated value of ($Value) for datapoint ($($Instance.Name)-$($Datapoint.Name)) using metric type ($($Datapoint.MetricType)) and model simulation type ($SimulationType)."
    }


    Return $Value
}