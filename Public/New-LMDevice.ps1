<#
.SYNOPSIS
Creates a new LogicMonitor device.

.DESCRIPTION
The New-LMDevice function creates a new LogicMonitor device with the specified parameters. It sends a POST request to the LogicMonitor API to create the device.

.PARAMETER Name
The name of the device. This parameter is mandatory.

.PARAMETER DisplayName
The display name of the device. This parameter is mandatory.

.PARAMETER Description
The description of the device.

.PARAMETER PreferredCollectorId
The ID of the preferred collector for the device.

.PARAMETER PreferredCollectorGroupId
The ID of the preferred collector group for the device.

.PARAMETER AutoBalancedCollectorGroupId
The ID of the auto-balanced collector group for the device.

.PARAMETER DeviceType
The type of the device. Default value is 0.

.PARAMETER Properties
A hashtable of custom properties for the device.

.PARAMETER HostGroupIds
An array of host group IDs for the device. Dynamic group IDs will be ignored, and the operation will replace all existing groups.

.PARAMETER Link
The link associated with the device.

.PARAMETER DisableAlerting
Specifies whether alerting is disabled for the device.

.PARAMETER EnableNetFlow
Specifies whether NetFlow is enabled for the device.

.PARAMETER NetflowCollectorGroupId
The ID of the NetFlow collector group for the device.

.PARAMETER NetflowCollectorId
The ID of the NetFlow collector for the device.

.PARAMETER LogCollectorGroupId
The ID of the log collector group for the device.

.PARAMETER LogCollectorId
The ID of the log collector for the device.

.EXAMPLE
New-LMDevice -Name "Server001" -DisplayName "Server 001" -Description "Web server" -PreferredCollectorId 1234 -HostGroupIds @("Group1", "Group2")

This example creates a new LogicMonitor device with the name "Server001", display name "Server 001", description "Web server", and preferred collector ID 1234. It assigns the device to host groups "Group1" and "Group2".

.NOTES
This function requires a valid API authentication. Make sure you are logged in before running any commands using Connect-LMAccount.
#>
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

        [Nullable[Int]]$NetflowCollectorId,

        [Nullable[Int]]$LogCollectorGroupId,

        [Nullable[Int]]$LogCollectorId
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
                    logCollectorGroupId       = $LogCollectorGroupId
                    logCollectorId            = $LogCollectorId
                    hostGroupIds              = $HostGroupIds -join ","
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
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
    End {}
}
