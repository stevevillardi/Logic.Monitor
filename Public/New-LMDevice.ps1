Function New-LMDevice {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$DisplayName,

        [String]$Description,

        [String]$PreferredCollectorId,

        [String]$PreferredCollectorGroupId,

        [Hashtable]$Properties,

        [String[]]$HostGroupIds, #Dynamic group ids will be ignored, operation will replace all existing groups

        [String]$Link,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [String]$NetflowCollectorGroupId,

        [String]$NetflowCollectorId
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($global:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/device/devices"

            #Loop through requests 
            $Done = $false
            While (!$Done) {
                Try {
                    $Data = @{
                        name                      = $Name
                        displayName               = $DisplayName
                        description               = $Description
                        disableAlerting           = $DisableAlerting
                        enableNetflow             = $EnableNetFlow
                        customProperties          = $customProperties
                        preferredCollectorId      = $PreferredCollectorId
                        preferredCollectorGroupId = $PreferredCollectorGroupId
                        link                      = $Link
                        netflowCollectorGroupId   = $NetflowCollectorGroupId
                        netflowCollectorId        = $NetflowCollectorId
                        hostGroupIds              = $HostGroupIds -join ","
                    }

                
                    #Remove empty keys so we dont overwrite them
                    @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
                
                    $Data = ($Data | ConvertTo-Json)
                    $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                    $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

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
        }
        Else {
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
