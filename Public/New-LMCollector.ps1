<#
.SYNOPSIS
Creates a new LogicMonitor collector.

.DESCRIPTION
The New-LMCollector function is used to create a new collector in LogicMonitor. It requires a description for the collector and supports various optional parameters such as BackupAgentId, CollectorGroupId, Properties, EnableFailBack, EnableFailOverOnCollectorDevice, EscalatingChainId, AutoCreateCollectorDevice, SuppressAlertClear, ResendAlertInterval, and SpecifiedCollectorDeviceGroupId.

.PARAMETER Description
The description of the collector.

.PARAMETER BackupAgentId
The ID of the backup agent.

.PARAMETER CollectorGroupId
The ID of the collector group.

.PARAMETER Properties
A hashtable of custom properties for the collector.

.PARAMETER EnableFailBack
Specifies whether failback is enabled for the collector.

.PARAMETER EnableFailOverOnCollectorDevice
Specifies whether failover is enabled on the collector device.

.PARAMETER EscalatingChainId
The ID of the escalation chain.

.PARAMETER AutoCreateCollectorDevice
Specifies whether to automatically create a collector device.

.PARAMETER SuppressAlertClear
Specifies whether to suppress alert clear.

.PARAMETER ResendAlertInterval
The interval for resending alerts.

.PARAMETER SpecifiedCollectorDeviceGroupId
The ID of the specified collector device group.

.EXAMPLE
New-LMCollector -Description "My Collector" -BackupAgentId 123 -CollectorGroupId 456 -Properties @{ "Key1" = "Value1"; "Key2" = "Value2" }

This example creates a new collector with the specified description, backup agent ID, collector group ID, and custom properties.

#>
Function New-LMCollector {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Description,

        [Nullable[Int]]$BackupAgentId,

        [Nullable[Int]]$CollectorGroupId,

        [Hashtable]$Properties,

        [Nullable[boolean]]$EnableFailBack,

        [Nullable[boolean]]$EnableFailOverOnCollectorDevice,

        [Nullable[Int]]$EscalatingChainId,

        [Nullable[boolean]]$AutoCreateCollectorDevice,

        [Nullable[boolean]]$SuppressAlertClear,

        [Nullable[Int]]$ResendAlertInterval,

        [Nullable[Int]]$SpecifiedCollectorDeviceGroupId

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
            $ResourcePath = "/setting/collector/collectors"

            Try {
                $Data = @{
                    description                     = $Description
                    backupAgentId                   = $BackupAgentId
                    collectorGroupId                = $CollectorGroupId
                    customProperties                = $customProperties
                    enableFailBack                  = $EnableFailBack
                    enableFailOverOnCollectorDevice = $EnableFailOverOnCollectorDevice
                    escalatingChainId               = $EscalatingChainId
                    needAutoCreateCollectorDevice   = $AutoCreateCollectorDevice
                    suppressAlertClear              = $SuppressAlertClear
                    resendIval                      = $ResendAlertInterval
                    netflowCollectorId              = $NetflowCollectorId
                    specifiedCollectorDeviceGroupId = $SpecifiedCollectorDeviceGroupId
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Collector" )
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
