<#
.SYNOPSIS
Copies a LogicMonitor dashboard to a new dashboard.

.DESCRIPTION
The Copy-LMDashboard function allows you to copy a LogicMonitor dashboard to a new dashboard. You can specify the name, ID, or group name of the dashboard to be copied, as well as provide a new name and optional description for the copied dashboard. The function requires valid API credentials and a logged-in session.

.PARAMETER Name
The name of the new dashboard.

.PARAMETER DashboardId
The ID of the dashboard to be copied. This parameter is mandatory when using the 'GroupId-Id' or 'GroupName-Id' parameter sets.

.PARAMETER DashboardName
The name of the dashboard to be copied. This parameter is mandatory when using the 'GroupId-Name' or 'GroupName-Name' parameter sets.

.PARAMETER Description
An optional description for the new dashboard.

.PARAMETER ParentGroupId
The ID of the parent group for the new dashboard. This parameter is mandatory when using the 'GroupId-Id' or 'GroupId-Name' parameter sets.

.PARAMETER ParentGroupName
The name of the parent group for the new dashboard. This parameter is mandatory when using the 'GroupName-Id' or 'GroupName-Name' parameter sets.

.EXAMPLE
Copy-LMDashboard -Name "New Dashboard" -DashboardId 12345 -ParentGroupId 67890
Copies the dashboard with ID 12345 to a new dashboard named "New Dashboard" in the group with ID 67890.

.EXAMPLE
Copy-LMDashboard -Name "New Dashboard" -DashboardName "Old Dashboard" -ParentGroupName "Group A"
Copies the dashboard named "Old Dashboard" to a new dashboard named "New Dashboard" in the group named "Group A".

.NOTES
Ensure that you are logged in before running any commands by using the Connect-LMAccount cmdlet.
#>
Function Copy-LMDashboard {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'GroupId-Id')]
        [Parameter(Mandatory, ParameterSetName = 'GroupName-Id')]
        [String]$DashboardId,

        [Parameter(Mandatory, ParameterSetName = 'GroupId-Name')]
        [Parameter(Mandatory, ParameterSetName = 'GroupName-Name')]
        [String]$DashboardName,

        [String]$Description,

        [Parameter(Mandatory, ParameterSetName = 'GroupId-Id')]
        [Parameter(Mandatory, ParameterSetName = 'GroupId-Name')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory, ParameterSetName = 'GroupName-Id')]
        [Parameter(Mandatory, ParameterSetName = 'GroupName-Name')]
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

        #Lookup Dashboard Id
        If($DashboardName) {
            $LookupResult = (Get-LMDashboard -Name $DashboardName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DashboardName) {
                return
            }
            $DashboardId = $LookupResult
        }

        #Get existing dashboard config
        $SourceDashboard = Get-LMDashboard -Id $DashboardId
        
        #Build header and uri
        $ResourcePath = "/dashboard/dashboards/$DashboardId/clone"

        Try {
            $Data = @{
                name                                = $Name
                description                         = $Description
                groupId                             = $ParentGroupId
                widgetTokens                        = $SourceDashboard.widgetTokens
                widgetsConfig                       = $SourceDashboard.widgetsConfig
                widgetsOrder                        = $SourceDashboard.widgetsOrder
                sharable                           = $SourceDashboard.sharable
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
