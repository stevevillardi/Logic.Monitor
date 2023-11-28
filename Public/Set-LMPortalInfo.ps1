Function Set-LMPortalInfo {

    [CmdletBinding()]
    Param (
        [String]$Whitelist,

        [Switch]$ClearWhitelist,

        [Nullable[boolean]]$RequireTwoFA,

        [Nullable[boolean]]$IncludeACKinAlertTotals,

        [Nullable[boolean]]$IncludeSDTinAlertTotals,

        [Nullable[boolean]]$EnableRemoteSession,

        [String]$CompanyDisplayName,

        [ValidateSet(30,60,120,240,480,1440,10080,43200)]
        [Nullable[Int]]$UserSessionTimeoutInMin

    )

    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/setting/companySetting"

            $Data = @{
                whiteList   = $Whitelist
                sessionTimeoutInSeconds   = $UserSessionTimeoutInMin * 60
                requireTwoFA   = $RequireTwoFA
                alertTotalIncludeInAck   = $IncludeACKinAlertTotals
                alertTotalIncludeInSdt   = $IncludeSDTinAlertTotals
                companyDisplayName   = $CompanyDisplayName
                enableRemoteSession   = $EnableRemoteSession
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }

            If($ClearWhitelist){
                $Data.whitelist = ""
            }

            $Data = ($Data | ConvertTo-Json)

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }

            Return $Response
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End{}
}
