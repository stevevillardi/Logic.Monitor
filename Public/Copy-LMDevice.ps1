Function Copy-LMDevice {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$DisplayName = $Name,

        [String]$Description,

        [Parameter(Mandatory)]
        $DeviceObject
    )
    #Check if we are logged in and have valid api creds
    Begin {
        Write-Output "[INFO]: Any custom properties from the reference device that are masked will need to be updated on the cloned resource as those values are not available to the LM API."
    }
    Process {
        If ($Script:LMAuth.Valid) {
            #Strip out dynamic groups
            $HostGroupIds = ($DeviceObjec.hostGroupIds -Split "," | Get-LMDeviceGroup | Where-Object {$_.appliesTo -eq ""}).Id -Join ","

            $Data = @{
                name                      = $Name
                displayName               = If($DisplayName){$DisplayName}Else{$DeviceObject.displayName}
                description               = If($Description){$Description}Else{$DeviceObject.description}
                disableAlerting           = $DeviceObject.disableAlerting
                enableNetflow             = $DeviceObject.enableNetFlow
                customProperties          = $DeviceObject.customProperties
                deviceType                = $DeviceObject.deviceType
                preferredCollectorId      = $DeviceObject.preferredCollectorId
                preferredCollectorGroupId = $DeviceObject.preferredCollectorGroupId
                autoBalancedCollectorGroupId = $DeviceObject.autoBalancedCollectorGroupId
                link                      = $DeviceObject.link
                netflowCollectorGroupId   = $DeviceObject.netflowCollectorGroupId
                netflowCollectorId        = $DeviceObject.netflowCollectorId
                logCollectorGroupId       = $DeviceObject.logCollectorGroupId
                logCollectorId            = $DeviceObject.logCollectorId
                hostGroupIds              = If($HostGroupIds){$HostGroupIds}Else{1}
            }
                    
            #Build header and uri
            $ResourcePath = "/device/devices"

            Try {
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

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
    End {
    }
}
