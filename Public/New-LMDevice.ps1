Function New-LMDevice {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$DisplayName,

        [String]$Description,
        
        [Parameter(Mandatory)]
        [Nullable[Int]]$PreferredCollectorId,

        [Nullable[Int]]$PreferredCollectorGroupId,

        [Nullable[Int]]$AutoBalancedCollectorGroupId,

        [Int]$DeviceType = 0,

        [Hashtable]$Properties,

        [String[]]$HostGroupIds, #Dynamic group ids will be ignored, operation will replace all existing groups

        [String]$Link,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [Nullable[Int]]$NetflowCollectorGroupId,

        [Nullable[Int]]$NetflowCollectorId
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/device/devices"

            Try {
                $Data = @{
                    name                      = $Name
                    displayName               = $DisplayName
                    description               = $Description
                    disableAlerting           = $DisableAlerting
                    enableNetflow             = $EnableNetFlow
                    customProperties          = $customProperties
                    deviceType                = $DeviceType
                    preferredCollectorId      = $PreferredCollectorId
                    preferredCollectorGroupId = $PreferredCollectorGroupId
                    autoBalancedCollectorGroupId = $AutoBalancedCollectorGroupId
                    link                      = $Link
                    netflowCollectorGroupId   = $NetflowCollectorGroupId
                    netflowCollectorId        = $NetflowCollectorId
                    hostGroupIds              = $HostGroupIds -join ","
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Device" )
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
