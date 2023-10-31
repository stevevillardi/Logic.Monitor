
Function Build-LMDataModel {
    [CmdletBinding(DefaultParameterSetName="ModelDatasources")]
    [OutputType([System.Collections.Generic.List[object]])]
    Param(
        [Parameter(Mandatory,ParameterSetName="ModelDatasources")]
        [System.Collections.Generic.List[object]]$DatasourceNames,

        [Switch]$ReplicateModuleGraphs,

        [Switch]$IncludeAlertThresholds,

        [Parameter(ParameterSetName = 'GenerateInstances')]
        [Parameter(Mandatory,ParameterSetName="ModelDatasources")]
        [Switch]$GenerateInstances,

        [Parameter(ParameterSetName = 'GenerateInstances')]
        [Parameter(Mandatory,ParameterSetName="ModelDatasources")]
        [Int]$InstanceCount = 1,

        [ValidateSet("8to5","random","replication","replay_model")]
        [String]$SimulationType="random",

        [Parameter(Mandatory)]
        [String]$DeviceHostName,

        [String]$DeviceDisplayName = $DeviceHostName,

        [Parameter(Mandatory,ParameterSetName = 'ModelDevice')]
        [String]$ModelDeviceHostName,

        [Parameter(ParameterSetName = 'ModelDevice')]
        [Switch]$IncludeModelDeviceProperties,

        [Parameter(ParameterSetName = 'ModelDevice')]
        [String]$ModelDeviceInstanceCount = 24,

        [Parameter(ParameterSetName = 'ModelDevice')]
        [Switch]$IncludeModelDeviceData

    )
    #If we have a model deivce make sure we can grab it from the connected portal fist
    If($ModelDeviceHostName){
        $DatasourceNames = [System.Collections.Generic.List[object]]::New()
        $ModelDevice = Get-LMDevice -Name $ModelDeviceHostName | Select-Object -First 1
        If($ModelDevice){
            Write-Debug "Located model device, using device ($ModelDeviceHostName) as model candidate.(ID: $($ModelDevice.id))"
            $ModelDeviceDatasources = Get-LMDeviceDatasourceList -id $ModelDevice.Id | Where-Object {$_.instanceNumber -gt 0}
            $DatasourceNames.AddRange($ModelDeviceDatasources.datasourceName)
        }
        Else{
            Write-Error "Unable to locate provided model device ($ModelDeviceHostName), ensure hostname is correct and try again."
            Return
        }
    }

    #If set to collect model data override simulation type to replay model
    If($IncludeModelDeviceData){$SimulationType = "replay_model"}

    $DataSourceModels = [System.Collections.Generic.List[object]]::New()
    #Loop through each provided DSName to generate models
    Foreach($DatasourceName in $DatasourceNames){
        #Grab specified source DS for DatasourceName so we can model it for PushMetrics
        Write-Debug "Using provided datasource name ($DatasourceName) as model candidate."
        $DatasourceInfo = Get-LMDatasource -Name $DatasourceName
        $Datasource = $DatasourceInfo | Select-Object description,tags,name,displayName,collectInterval,hasMultiInstances,dataPoints
        #Do we have a valid DS to model
        If($Datasource){
            #Extract what we need from the source datasource to use as basis for modeling
            $DatasourceDefenition = $Datasource | Select-Object description,tags,name,displayName,collectInterval,hasMultiInstances
            $Datapoints = $Datasource.datapoints
            $DatasourceGroupName = $Datasource.group

            #Estimate datapoint type for model generation
            $DatapointDefenition = [System.Collections.Generic.List[object]]::New()
            Foreach ($Datapoint in $Datapoints){
                $MetricType = Resolve-MetricType -Datapoint $Datapoint.name
                If($Datapoint.postProcessorMethod -eq "expression"){
                    $Type = "complex"
                    $ComplexDatapointFormula = $Datapoint.postProcessorParam
                }
                Else{
                    $Type = "standard"
                    $ComplexDatapointFormula = "N/A"
                }

                Write-Debug "Detected $Type datapoint $($Datapoint.name) matching metric type: $MetricType"

                $DatapointDefenition.Add([PSCustomObject]@{
                    Name                    = $Datapoint.name
                    MaxValue                = $Datapoint.maxValue
                    MinValue                = $Datapoint.minValue
                    Description             = $Datapoint.description
                    Type                    = $Type
                    ComplexDatapointFormula = $ComplexDatapointFormula
                    AlertForNoData          = If($IncludeAlertThresholds){[Boolean]!$Datapoint.alertForNoData}
                    AlertExpr               = If($IncludeAlertThresholds){$Datapoint.alertExpr}
                    AlertSubject            = If($IncludeAlertThresholds){$Datapoint.alertSubject}
                    AlertBody               = If($IncludeAlertThresholds){$Datapoint.alertBody}
                    MetricType              = $MetricType
                })
            }

            #Get Graph settings we will need to model our PushMetric DS after
            If($ReplicateModuleGraphs){
                Write-Debug "Exporting existing datasource overview graph defenition(s) for model export."
                $DatasourceGraphModel  = Get-LMDatasourceGraph -DatasourceName $Datasource.Name | Select-Object -ExcludeProperty id

                Write-Debug "Exporting existing datasource instance graph defenition(s) for model export."
                $DatasourceOverviewGraphModel = Get-LMDatasourceOverviewGraph -DatasourceName $Datasource.Name | Select-Object -ExcludeProperty id
            }

            #Generate Instances if not specified
            $Instances = [System.Collections.Generic.List[object]]::New()
            If($GenerateInstances -and [Boolean]$Datasource.hasMultiInstances){
                Write-Debug "Generating $InstanceCount instance(s) for data model export."
                $Instances.AddRange($(Build-Instance -InstanceCount $InstanceCount -Datasource $DatasourceDefenition))
            }
            ElseIf($GenerateInstances){
                Write-Debug "Datasource $($Datasource.name) not enabled for multiple instances, default instance creation to single instance for data model export."
                $Instances.Add($(Build-Instance -SingleInstance -Datasource $DatasourceDefenition))
            }
            ElseIf($ModelDeviceHostName -and $ModelDeviceDatasources){
                $ModelInstances = Get-LMDeviceDatasourceInstance -DatasourceId $DatasourceInfo.Id -DeviceId $ModelDevice.Id
                Write-Debug "Datasource $($Datasource.name) is being model after device $($ModelDevice.DisplayName) , adding up to $ModelDeviceInstanceCount instances from pool of $(($ModelInstances | Measure-Object).Count) existing instance(s) to data model export."
                If($($ModelInstances | Measure-Object).Count -gt 1){
                    $Instances.AddRange($(Build-Instance -ModelInstance -InstanceList $($ModelInstances | Sort-Object -Property Id | Select-Object -First $ModelDeviceInstanceCount) -Datasource $DatasourceDefenition -IncludeModelData:$IncludeModelDeviceData -ModelDeviceHostName $ModelDeviceHostName))
                }
                Else{
                    $Instances.Add($(Build-Instance -ModelInstance -InstanceList $ModelInstances -Datasource $DatasourceDefenition -IncludeModelData:$IncludeModelDeviceData -ModelDeviceHostName $ModelDeviceHostName))
                }
            }

            #Combine our model info together for export
            $DataSourceModel = [PSCustomObject]@{
                DatasourceName = $DatasourceName
                DatasourceGroupName = $DatasourceGroupName
                Instances = $Instances
                Defenition = $DatasourceDefenition
                Datapoints = $DatapointDefenition
                OverviewGraphs = $DatasourceOverviewGraphModel
                Graphs = $DatasourceGraphModel
            }
        }
        Write-Debug "Exporting data model ($DatasourceName)."
        $DataSourceModels.Add($DataSourceModel)
    }

    $PropertiesHash = @{}
    If($IncludeModelDeviceProperties){
        $Properties = $($ModelDevice.autoProperties + $ModelDevice.customProperties) | Where-Object {$_.name -notmatch ".pass|.community|.key|.cert|.secret|.user|system.|.id"}

        Foreach ($Prop in $Properties){
            $Prop.name = "autodiscovery." + $Prop.name.replace("auto.","")
            $PropertiesHash.Add($Prop.name,$Prop.value)
        }
    }

    $DeviceModel = [PSCustomObject]@{
        HostName = $DeviceHostName
        DisplayName = $DeviceDisplayName
        Properties = $PropertiesHash
        SimulationType = $SimulationType
        Datasources = $DataSourceModels
    }
    Return $DeviceModel
}

Function Resolve-MetricType {
    Param(
        [Parameter(Mandatory)]
        [Object]$Datapoint
    )

    Switch -Regex ($Datapoint){
        '[Pp]kts|[Bb]ps|[Mm]bps|[Rr]ate|[Tt]ime|[Dd]uration'                {Return "Rate"}
        '[Pp]ercent|[Uu]til'                                                {Return "Percentage"}
        '[Ww]rite|[Rr]ead|[Ii]ops'                                          {Return "IO-Latency"}
        '[Ff]ree|[Uu]sed|[Rr]eserved|[Aa]vailable'                          {Return "SpaceUsage"}
        '[Ss]tatus|[Ss]tate|[Ee]nabled'                                     {Return "Status"}
        default                                                             {Return "Count"}
    }
}

Function Build-Instance {
    Param(
        [Switch]$SingleInstance,

        [Switch]$ModelInstance,

        [System.Collections.Generic.List[object]]$InstanceList,

        [Int]$InstanceCount,

        [Boolean]$IncludeModelData,

        [String]$ModelDeviceHostName,

        $Datasource
    )

    $Instances = [System.Collections.Generic.List[object]]::New()

    #If single instance just return datasource name as instance
    If($SingleInstance){
        Write-Debug "Single instance datasource detected, skipping instance generation usings datasource name as instance"
        $Instances.Add([PSCustomObject]@{
            Name            = ($Datasource.name -replace '[#\\/();=]', '_')
            DisplayName     = ($Datasource.displayName -replace '[#\\/;=]', '_')
            Description     = ""
            Properties        = @{}
            Type            = "SingleInstance"
            Data            = @()
        })

        Return $Instances
    }

    If($ModelInstance){
        #Add generated instance to instance list
        Write-Debug "Instances found for export: ($(($InstanceList[0..9].Name -Join ","))...)"
        Foreach($Instance in $InstanceList){
            $Data = [System.Collections.Generic.List[object]]::New()
            If($IncludeModelData){
                Write-Debug "Extracting last 24 hours of model device data for instance ($($Instance.name))"
                $InstanceData = Get-LMDeviceData -DeviceName $ModelDeviceHostName -DatasourceName $Datasource.name -InstanceName $Instance.name -StartDate (Get-Date).AddHours(-24) -EndDate (Get-Date)
                If($InstanceData){
                    $DataCount = ($InstanceData | Measure-Object).Count
                    Write-Debug "Added $DataCount time series metrics to data model for ($($Instance.name))"
                    $Data.AddRange($InstanceData)
                }
                Else{
                    Write-Debug "No recent instance data found for ($($Instance.name))"
                }
            }
            
            If($IncludeModelDeviceProperties){
                $PropertiesHash = @{}
                $Properties = $($Instance.customProperties + $Instance.autoProperties) | Where-Object {$_.name -notmatch ".pass|.community|.key|.cert|.secret|.user|system.|.id"}

                Foreach ($Prop in $Properties){
                    $Prop.name = "autodiscovery." + $Prop.name.replace("auto.","")
                    $PropertiesHash.Add($Prop.name,$Prop.value)
                }
            }

            $Instances.Add([PSCustomObject]@{
                Name            = (($Instance.name -replace '[#\\/;=]', '_') -replace '[\[\]{}]','')
                DisplayName     = If($Instance.displayName){(($Instance.displayName -replace '[#\\;=]', '_') -replace '[\[\]{}]','')}Else{(($Datasource.displayName -replace '[#\\;=]', '_'))}
                Description     = $Instance.description
                Properties       = $PropertiesHash
                Type            = "DeviceModeled"
                Data            = $Data
            })
        }

        Return $Instances
    }
    Else{
        If($Datasource.tags){
            $Type = Switch -Regex ($Datasource.tags){
                'inode|disk|drive'                  {"Disk"}
                'filesystem|file'                   {"FileSystem"}
                'core|cpu|processor'                {"CPU"}
                'vlan'                              {"VLAN"}
                'chassis|array|cluster|node'        {"Node"}
                'pdu|ups|battery'                   {"Battery"}
                'psu|power'                         {"PowerSupply"}
                'temperature|voltage'               {"Sensor"}
                'interface|port'                    {"Interface"}
                'ec2|compute engine|vm'             {"Server"}
                default                             {"Instance"}
            }
        }
        Else{
            $Type = "Unknown"
        }
        Write-Debug "Datasource instance type detected as $Type, using type for instance generation"

        #For multiple instances loop through and generate insance types
        For (($i = 1); $i -le $InstanceCount; $i++){
            #Generate instance name based on tags and dp names
            $Name = $Type + '{0:d2}' -f $i
            $DisplayName = $Type + '{0:d2}' -f $i
            $Description = ""

            #Add generated instance to instance list
            $Instances.Add([PSCustomObject]@{
                Name            = ($Name -replace '[#\\;=]', '_')
                DisplayName     = ($DisplayName -replace '[#\\;=]', '_')
                Description     = $Description
                Properties        = @{}
                Type            = $Type
                Data            = @()
            })
        }
    }

    Return $Instances
}