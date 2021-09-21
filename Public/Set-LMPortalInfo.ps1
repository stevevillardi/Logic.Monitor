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

    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {
        
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
        @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

        If($ClearWhitelist){
            $Data.whitelist = ""
        }

        $Data = ($Data | ConvertTo-Json)

        Try {
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data
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
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
