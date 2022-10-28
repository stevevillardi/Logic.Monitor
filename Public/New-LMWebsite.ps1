Function New-LMWebsite {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [Nullable[boolean]]$IsInternal = $false,

        [String]$Description,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$UseDefaultAlertSetting = $true,

        [Nullable[boolean]]$UseDefaultLocationSetting = $true,

        [Nullable[boolean]]$TriggerSSLStatusAlert,
        
        [Nullable[boolean]]$TriggerSSLExpirationAlert,

        [String]$GroupId,

        [Parameter(Mandatory)]
        [String]$Hostname,

        [ValidateSet("http", "https")]
        [String]$HttpType,

        [String[]]$SSLAlertThresholds,

        [ValidateSet(5, 10, 15, 20, 30, 60)]
        [Nullable[Int]]$PingCount,

        [Nullable[Int]]$PingTimeout,

        [Nullable[Int]]$PageLoadAlertTimeInMS,

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

        [Parameter(Mandatory)]
        [ValidateSet("pingcheck", "webcheck")]
        [String]$Type


    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        $Steps = @()
        If ($Type -eq "webcheck") {
            $Steps += [PSCustomObject]@{
                useDefaultRoot    = $true
                url               = ""
                HTTPVersion       = "1.1"
                HTTPMethod        = "GET"
                followRedirection = $true
                fullpageLoad      = $false
                requireAuth       = $false
                matchType         = "plain"
                path              = ""
                keyword           = ""
                invertMatch       = $false
                statusCode        = ""
                type              = "config"
                HTTPBody          = ""
                postDataEditType  = "raw"
                HTTPHeaders       = ""
                auth              = @{
                    type     = "basic"
                    domain   = ""
                    userName = ""
                    password = ""
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
                host                        = $Hostname
                triggerSSLStatusAlert       = $TriggerSSLStatusAlert
                triggerSSLExpirationAlert   = $TriggerSSLExpirationAlert
                count                       = $PingCount
                percentPktsNotReceiveInTime = $PingPercentNotReceived
                timeoutInMSPktsNotReceive   = $PingTimeout
                transition                  = $FailedCount
                pageLoadAlertTimeInMS       = $PageLoadAlertTimeInMS
                alertExpr                   = $AlertExp
                schema                      = $HttpType
                domain                      = $Hostname
                type                        = $Type
                steps                       = $Steps
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and $_ -ne "steps") { $Data.Remove($_) } }
        
            $Data = ($Data | ConvertTo-Json -Depth 5)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

            Return $Response
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
