<#
.SYNOPSIS
Creates a new LogicMonitor device group.

.DESCRIPTION
The New-LMDeviceGroup function creates a new LogicMonitor device group with the specified parameters.

.PARAMETER Name
The name of the device group. This parameter is mandatory.

.PARAMETER Description
The description of the device group.

.PARAMETER Properties
A hashtable of custom properties for the device group.

.PARAMETER DisableAlerting
Specifies whether alerting is disabled for the device group. The default value is $false.

.PARAMETER EnableNetFlow
Specifies whether NetFlow is enabled for the device group. The default value is $false.

.PARAMETER ParentGroupId
The ID of the parent device group. This parameter is mandatory when using the 'GroupId' parameter set.

.PARAMETER ParentGroupName
The name of the parent device group. This parameter is mandatory when using the 'GroupName' parameter set.

.PARAMETER AppliesTo
The applies to value for the device group.

.EXAMPLE
New-LMDeviceGroup -Name "MyDeviceGroup" -Description "This is a test device group" -Properties @{ "Location" = "US"; "Environment" = "Production" } -DisableAlerting $true

This example creates a new LogicMonitor device group named "MyDeviceGroup" with a description and custom properties. Alerting is disabled for this device group.

.EXAMPLE
New-LMDeviceGroup -Name "ChildDeviceGroup" -ParentGroupName "ParentDeviceGroup"

This example creates a new LogicMonitor device group named "ChildDeviceGroup" with a specified parent device group.

.NOTES
This function requires a valid LogicMonitor API authentication. Use Connect-LMAccount to authenticate before running this command.
#>
Function New-LMDeviceGroup {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$Properties,

        [Boolean]$DisableAlerting = $false,

        [Boolean]$EnableNetFlow = $false,

        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$ParentGroupName,

        [String]$AppliesTo
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup ParentGroupName
        If ($ParentGroupName) {
            If ($ParentGroupName -Match "\*") {
                Write-Error "Wildcard values not supported for groups names."
                return
            }
            $ParentGroupId = (Get-LMDeviceGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            If (!$ParentGroupId) {
                Write-Error "Unable to find group: $ParentGroupName, please check spelling and try again."
                return
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
        $ResourcePath = "/device/groups"

        Try {
            $Data = @{
                name                                = $Name
                description                         = $Description
                appliesTo                           = $AppliesTo
                disableAlerting                     = $DisableAlerting
                enableNetflow                       = $EnableNetFlow
                customProperties                    = $customProperties
                parentId                            = $ParentGroupId
                defaultAutoBalancedCollectorGroupId = 0
                defaultCollectorGroupId             = 0
                defaultCollectorId                  = 0
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
