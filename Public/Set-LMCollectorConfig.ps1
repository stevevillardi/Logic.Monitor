Function Set-LMCollectorConfig {

    [CmdletBinding(SupportsShouldProcess,ConfirmImpact='None')]
    Param (

        [Parameter(ParameterSetName = 'Id-Conf', ValueFromPipelineByPropertyName)]
        [Parameter(ParameterSetName = 'Id-SnippetConf', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name-Conf')]
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [String]$Name,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [ValidateSet("nano","small", "medium", "large", "extra_large", "double_extra_large")]
        [String]$CollectorSize,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$CollectorConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$SbproxyConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$WatchdogConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$WebsiteConf,

        [Parameter(ParameterSetName = 'Id-Conf')]
        [Parameter(ParameterSetName = 'Name-Conf')]
        [String]$WrapperConf,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$SnmpThreadPool,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$SnmpPduTimeout,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$ScriptThreadPool,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$ScriptTimeout,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$BatchScriptThreadPool,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$BatchScriptTimeout,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$PowerShellSPSEProcessCountMin,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Int]]$PowerShellSPSEProcessCountMax,

        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Boolean]]$NetflowEnable,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Boolean]]$NbarEnable,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [String[]]$NetflowPorts,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [String[]]$SflowPorts,
        
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [Nullable[Boolean]]$LMLogsSyslogEnable,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [ValidateSet("IP", "FQDN", "HOSTNAME")]
        [String]$LMLogsSyslogHostnameFormat,
        [Parameter(ParameterSetName = 'Name-SnippetConf')]
        [Parameter(ParameterSetName = 'Id-SnippetConf')]
        [String]$LMLogsSyslogPropertyName,

        [Switch]$WaitForRestart

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        Function Process-CollectorConfig {
            Param(
                $Config,
                $ConfLine,
                $Value
            )

            $Value = $Value.toString().toLower()

            $ConfigArray = $Config.Split([Environment]::NewLine)
            [int[]]$Index = [Linq.Enumerable]::Range(0, $ConfigArray.Count).Where({ param($i) $ConfigArray[$i] -match $ConfLine })
            If(($Index | Measure-Object).Count -eq 1){
                Write-LMHost "[INFO]: Updating config parameter $ConfLine to value $Value."
                $ConfigArray[$Index[0]]="$ConfLine=$Value"
            }
            Else{
                Write-LMHost "[WARN]: Multiple matches found for config parameter $ConfLine, skipping processing."  -ForegroundColor Yellow
            }
            
            Return ([string]::Join([Environment]::NewLine,$ConfigArray))
        }
        
        If ($Script:LMAuth.Valid) {
            
            #Lookup Collector Name
            If ($Name) {
                $LookupResult = (Get-LMCollector -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            If($PSCmdlet.ParameterSetName -like "*Snippet*"){
                $CollectorConfData = (Get-LMCollector -Id $Id).collectorConf
                
                If($CollectorConfData){
                    $SnippetArray = [System.Collections.ArrayList]@()
                    $cmdName = $MyInvocation.InvocationName
                    $paramList = (Get-Command -Name $cmdName).Parameters
                    foreach ( $key in $paramList.Keys ) {
                        $value = (Get-Variable $key -ErrorAction SilentlyContinue).Value
                        if ( ($value -or $value -eq 0) -and ($key -ne "Id" -and $key -ne "Name" -and $key -ne "WaitForRestart") ) {
                            $SnippetArray.Add(@{$key = $value}) | Out-Null
                        }
                    }
                    
                    Foreach ($Key in $SnippetArray.Keys){
                        $CollectorConfData = Switch($Key){
                            "SnmpThreadPool" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "collector.snmp.threadpool" -Value $SnippetArray.$Key}
                            "SnmpPduTimeout" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "snmp.pdu.timeout" -Value $SnippetArray.$Key}
                            "ScriptThreadPool" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "collector.script.threadpool" -Value $SnippetArray.$Key}
                            "ScriptTimeout" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "collector.script.timeout" -Value $SnippetArray.$Key}
                            "BatchScriptThreadPool" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "collector.batchscript.threadpool" -Value $SnippetArray.$Key}
                            "BatchScriptTimeout" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "collector.batchscript.timeout" -Value $SnippetArray.$Key}
                            "PowerShellSPSEProcessCountMin" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "powershell.spse.process.count.min" -Value $SnippetArray.$Key}
                            "PowerShellSPSEProcessCountMax" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "powershell.spse.process.count.max" -Value $SnippetArray.$Key}
                            "NetflowEnable" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.enable" -Value $SnippetArray.$Key}
                            "NbarEnable" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.nbar.enabled" -Value $SnippetArray.$Key}
                            "NetflowPorts" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.ports" -Value $SnippetArray.$Key}
                            "SflowPorts" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "netflow.sflow.ports" -Value $SnippetArray.$Key}
                            "LMLogsSyslogEnable" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "lmlogs.syslog.enabled" -Value $SnippetArray.$Key}
                            "LMLogsSyslogHostnameFormat" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "lmlogs.syslog.hostname.format" -Value $SnippetArray.$Key}
                            "LMLogsSyslogPropertyName" { Process-CollectorConfig -Config $CollectorConfData -ConfLine "lmlogs.syslog.property.name" -Value $SnippetArray.$Key}
                            default {$CollectorConfData}
                        }
                    }
                }
            }
            Else{
                $CollectorConfData = $CollectorConf
            }
            
            #Build header and uri
            $ResourcePath = "/setting/collector/collectors/$Id/services/restart"
            
            If($PSItem){
                $Message = "Id: $Id | Name: $($PSItem.hostname) | Description: $($PSItem.description)"
            }
            ElseIf($Name){
                $Message = "Id: $Id | Name: $Name)"
            }
            Else{
                $Message = "Id: $Id"
            }
            
            Try {
                $Data = @{
                    collectorSize                   = $CollectorSize
                    collectorConf                   = $CollectorConfData
                    sbproxyConf                     = $SbproxyConf
                    watchdogConf                    = $WatchdogConf
                    websiteConf                     = $WebsiteConf
                    wrapperConf                     = $WrapperConf
                }
                
                
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
                
                $Data = ($Data | ConvertTo-Json)
                
                If ($PSCmdlet.ShouldProcess($Message, "Set Collector Config ")) {  
                    Write-LMHost "[WARN]: This command will restart the targeted collector on update of the configuration"  -ForegroundColor Yellow
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
                    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    If($WaitForRestart){
                        $JobStarted = $false
                        $Tries = 0
                        While(!$JobStarted -or $Tries -eq 5){
                            #Build header and uri
                            $ResourcePath = "/setting/collector/collectors/$Id/services/restart/$Response"
                            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
        
                            $SubmitResponse = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]
                            If($SubmitResponse.errorMessage -eq "The task is still running"){
                                Write-LMHost "[INFO]: The task is still running..."
                                Start-Sleep -Seconds 2
                                $Tries++
                            }
                            Else{
                                $JobStarted = $true
                            }
                        }
                        Return "Job status code: $($SubmitResponse.jobStatus), Job message: $($SubmitResponse.jobErrmsg)"
                    }
                    Else{
                        Return "Successfully submitted restart request(jobID:$Response) with updated configurations. Collector will restart once the request has been picked up."
                    }
                }
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
