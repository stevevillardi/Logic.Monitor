<#
.SYNOPSIS
Creates a new LogicMonitor dashboard group.

.DESCRIPTION
The New-LMDashboardGroup function is used to create a new dashboard group in LogicMonitor. It requires a name for the group and can optionally include a description, widget tokens, and either the parent group ID or parent group name.

.PARAMETER Name
The name of the dashboard group. This parameter is mandatory.

.PARAMETER Description
The description of the dashboard group. This parameter is optional.

.PARAMETER WidgetTokens
A hashtable containing widget tokens. This parameter is optional.

.PARAMETER ParentGroupId
The ID of the parent group. This parameter is mandatory when using the 'GroupId' parameter set.

.PARAMETER ParentGroupName
The name of the parent group. This parameter is mandatory when using the 'GroupName' parameter set.

.EXAMPLE
New-LMDashboardGroup -Name "MyDashboardGroup" -Description "This is a sample dashboard group" -WidgetTokens @{ "Token1" = "Value1"; "Token2" = "Value2" } -ParentGroupId 123

This example creates a new dashboard group named "MyDashboardGroup" with a description and widget tokens. It sets the parent group using the parent group ID.

.EXAMPLE
New-LMDashboardGroup -Name "MyDashboardGroup" -Description "This is a sample dashboard group" -WidgetTokens @{ "Token1" = "Value1"; "Token2" = "Value2" } -ParentGroupName "ParentGroup"

This example creates a new dashboard group named "MyDashboardGroup" with a description and widget tokens. It sets the parent group using the parent group name.

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure to log in using the Connect-LMAccount function before running this command.
#>
Function New-LMDashboardGroup {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$WidgetTokens,

        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$ParentGroupName
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup ParentGroupName
        If ($ParentGroupName) {
            If ($ParentGroupName -Match "\*") {
                Write-Error "Wildcard values not supported for groups names."
                return
            }
            $ParentGroupId = (Get-LMDashboardGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            If (!$ParentGroupId) {
                Write-Error "Unable to find dashboard group: $ParentGroupName, please check spelling and try again." 
                return
            }
        }

        #Build custom props hashtable
        $WidgetTokensArray = @()
        If ($WidgetTokens) {
            Foreach ($Key in $WidgetTokens.Keys) {
                $WidgetTokensArray += @{name = $Key; value = $WidgetTokens[$Key] }
            }
        }
        
        #Build header and uri
        $ResourcePath = "/dashboard/groups"

        Try {
            $Data = @{
                name                                = $Name
                description                         = $Description
                parentId                            = $ParentGroupId
                widgetTokens                        = $WidgetTokensArray
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
