Function New-LMWebsite {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName="Website")]
        [Switch]$WebCheck,

        [Parameter(Mandatory,ParameterSetName="Ping")]
        [Switch]$PingCheck,

        [Parameter(Mandatory)]
        [String]$Name,

        [Nullable[boolean]]$IsInternal = $false,

        [String]$Description,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$UseDefaultAlertSetting = $true,

        [Nullable[boolean]]$UseDefaultLocationSetting = $true,

        [Parameter(ParameterSetName="Website")]
        [Nullable[boolean]]$TriggerSSLStatusAlert,
        
        [Parameter(ParameterSetName="Website")]
        [Nullable[boolean]]$TriggerSSLExpirationAlert,

        [String]$GroupId,

        [Parameter(Mandatory,ParameterSetName="Ping")]
        [String]$PingAddress,

        [Parameter(Mandatory,ParameterSetName="Website")]
        [String]$WebsiteDomain,

        [Parameter(ParameterSetName="Website")]
        [ValidateSet("http", "https")]
        [String]$HttpType = "https",

        [Parameter(ParameterSetName="Website")]
        [String[]]$SSLAlertThresholds,

        [Parameter(ParameterSetName="Ping")]
        [ValidateSet(5, 10, 15, 20, 30, 60)]
        [Nullable[Int]]$PingCount,

        [Parameter(ParameterSetName="Ping")]
        [Nullable[Int]]$PingTimeout,

        [Parameter(ParameterSetName="Website")]
        [Nullable[Int]]$PageLoadAlertTimeInMS,

        [Parameter(ParameterSetName="Website")]
        [Nullable[boolean]]$IgnoreSSL,

        [Parameter(ParameterSetName="Ping")]
        [ValidateSet(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)]
        [Nullable[Int]]$PingPercentNotReceived,

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 30, 60)]
        [Nullable[Int]]$FailedCount,

        [ValidateSet("warn", "error", "critical")]
        [String]$OverallAlertLevel,

        [ValidateSet("warn", "error", "critical")]
        [String]$IndividualAlertLevel,

        [Hashtable]$Properties,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [ValidateSet(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)]
        [Nullable[Int]]$PollingInterval,

        [Parameter(ParameterSetName="Website")]
        [Object[]]$WebsiteSteps,

        [Parameter(ParameterSetName="Website")]
        [Object[]]$CheckPoints
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If($Webcheck){
            $Type = "webcheck"
        }
        Else{
            $Type = "pingcheck"
        }

        
        $Steps = @()
        If ($Type -eq "webcheck") {
            If($WebsiteSteps){
                $Steps = $WebsiteSteps
            }
            Else{
                $Steps += [PSCustomObject]@{
                    useDefaultRoot    = $true
                    url               = ""
                    HTTPVersion       = "1.1"
                    HTTPMethod        = "GET"
                    HTTPHeaders       = ""
                    HTTPBody          = ""
                    followRedirection = $true
                    fullpageLoad      = $false
                    requireAuth       = $false
                    matchType         = "plain"
                    invertMatch       = $false
                    path              = ""
                    keyword           = ""
                    statusCode        = ""
                    type              = "config"
                    postDataEditType  = "raw"
                    auth              = @{
                        type     = "basic"
                        domain   = ""
                        userName = ""
                        password = ""
                    }
                }
            }
        }
        
        #Build custom props hashtable
        $customProperties = @()
        If ($Properties) {
            Foreach ($Key in $Properties.Keys) {
                $customProperties += @{name = $Key; value = $Properties[$Key] }
            }
        }
        
        #Build header and uri
        $ResourcePath = "/website/websites"
        
        Try {
            $AlertExp = ""
            If ($SSLAlertThresholds) {
                $AlertExp = "< " + $SSLAlertThresholds -join " "
            }
            
            $Data = @{
                name                        = $Name
                description                 = $Description
                disableAlerting             = $DisableAlerting
                isInternal                  = $IsInternal
                properties                  = $customProperties
                stopMonitoring              = $StopMonitoring
                groupId                     = $GroupId
                pollingInterval             = $PollingInterval
                overallAlertLevel           = $OverallAlertLevel
                individualAlertLevel        = $IndividualAlertLevel
                useDefaultAlertSetting      = $UseDefaultAlertSetting
                useDefaultLocationSetting   = $UseDefaultLocationSetting
                host                        = $PingAddress
                triggerSSLStatusAlert       = $TriggerSSLStatusAlert
                triggerSSLExpirationAlert   = $TriggerSSLExpirationAlert
                count                       = $PingCount
                ignoreSSL                   = $IgnoreSSL
                percentPktsNotReceiveInTime = $PingPercentNotReceived
                timeoutInMSPktsNotReceive   = $PingTimeout
                transition                  = $FailedCount
                pageLoadAlertTimeInMS       = $PageLoadAlertTimeInMS
                alertExpr                   = $AlertExp
                schema                      = $HttpType
                domain                      = $WebsiteDomain
                type                        = $Type
                steps                       = $Steps
            }
            
            If($CheckPoints){
                $TestLocations = [PSCustomObject]@{
                    all = $true
                    smgIds = @()
                    collectorIds = @($CheckPoints.smgId.GetEnumerator() | Foreach-Object {If($_ -ne 0){[Int]$_}})
                }

                $Data.checkpoints  = $CheckPoints
                $Data.testLocation = $TestLocations
            }
            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and $_ -ne "testLocation" -and $_ -ne "steps" -and  $_ -ne "checkpoints") { $Data.Remove($_) } }
            $Data = ($Data | ConvertTo-Json -Depth 5)
            
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Website" )
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
