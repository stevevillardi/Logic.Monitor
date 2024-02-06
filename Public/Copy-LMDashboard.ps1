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
