Function New-LMWebsite
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [Nullable[boolean]]$IsInternal,

        [String]$Description,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        [Nullable[boolean]]$UseDefaultAlertSetting,

        [Nullable[boolean]]$UseDefaultLocationSetting,

        [Nullable[boolean]]$TriggerSSLStatusAlert,
        
        [Nullable[boolean]]$TriggerSSLExpirationAlert,

        [String]$GroupId,

        [Parameter(Mandatory)]
        [String]$Hostname,

        [ValidateSet("http","https")]
        [String]$HttpType,

        [String[]]$SSLAlertThresholds,

        [ValidateSet(5,10,15,20,30,60)]
        [Nullable[Int]]$PingCount,

        [Nullable[Int]]$PingTimeout,

        [Nullable[Int]]$PageLoadAlertTimeInMS,

        [ValidateSet(10,20,30,40,50,60,70,80,90,100)]
        [Nullable[Int]]$PingPercentNotReceived,

        [ValidateSet(1,2,3,4,5,6,7,8,9,10,30,60)]
        [Nullable[Int]]$FailedCount,

        [ValidateSet("warn","error","critical")]
        [String]$OverallAlertLevel,

        [ValidateSet("warn","error","critical")]
        [String]$IndividualAlertLevel,

        [Hashtable]$Properties,

        [ValidateSet("Add","Replace","Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [ValidateSet(1,2,3,4,5,6,7,8,9,10)]
        [Nullable[Int]]$PollingInterval,

        [Parameter(Mandatory)]
        [ValidateSet("pingcheck","webcheck")]
        [String]$Type


    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        #Build custom props hashtable
        $customProperties = @()
        If($Properties){
            Foreach($Key in $Properties.Keys){
                $customProperties += @{name=$Key;value=$Properties[$Key]}
            }
        }
                
        #Build header and uri
        $ResourcePath = "/website/websites"

        #Loop through requests 
        Try{
            $Data = @{
                name = $Name
                description = $Description
                disableAlerting = $DisableAlerting
                isInternal = $IsInternal
                properties =  $customProperties
                stopMonitoring = $StopMonitoring
                groupId = $GroupId
                pollingInterval = $PollingInterval
                overallAlertLevel = $OverallAlertLevel
                individualAlertLevel = $IndividualAlertLevel
                useDefaultAlertSetting = $UseDefaultAlertSetting
                useDefaultLocationSetting = $UseDefaultLocationSetting
                host = $Hostname
                triggerSSLStatusAlert = $TriggerSSLStatusAlert
                triggerSSLExpirationAlert = $TriggerSSLExpirationAlert
                count = $PingCount
                percentPktsNotReceiveInTime = $PingPercentNotReceived
                timeoutInMSPktsNotReceive = $PingTimeout
                transition = $FailedCount
                pageLoadAlertTimeInMS = $PageLoadAlertTimeInMS
                alertExpr = "< " + $SSLAlertThresholds -join " "
                schema = $HttpType
                domain = $Hostname
                type = $Type

            }

            
            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

            Return $Response
        }
        Catch [Exception] {
            $Exception = $PSItem
            Switch($PSItem.Exception.GetType().FullName){
                {"System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException"} {
                    $HttpException = ($Exception.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                    $HttpStatusCode = $Exception.Exception.Response.StatusCode.value__
                    Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
                }
                default {
                    $LMError = $Exception.ToString()
                    Write-Error "Failed to execute web request: $LMError"
                }
            }
        }
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
