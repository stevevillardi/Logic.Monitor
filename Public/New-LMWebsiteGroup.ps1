<#
.SYNOPSIS
Creates a new LogicMonitor website group.

.DESCRIPTION
The New-LMWebsiteGroup function creates a new website group in LogicMonitor. It allows you to specify the name, description, properties, and parent group of the website group.

.PARAMETER Name
The name of the website group. This parameter is mandatory.

.PARAMETER Description
The description of the website group.

.PARAMETER Properties
A hashtable of custom properties for the website group.

.PARAMETER DisableAlerting
Specifies whether to disable alerting for the website group. By default, alerting is enabled.

.PARAMETER StopMonitoring
Specifies whether to stop monitoring the website group. By default, monitoring is not stopped.

.PARAMETER ParentGroupId
The ID of the parent group. This parameter is mandatory if the ParentGroupName parameter is not specified.

.PARAMETER ParentGroupName
The name of the parent group. This parameter is mandatory if the ParentGroupId parameter is not specified.

.EXAMPLE
New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupId 1234

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group ID 1234.

.EXAMPLE
New-LMWebsiteGroup -Name "MyWebsiteGroup" -Description "This is my website group" -ParentGroupName "ParentGroup"

This example creates a new website group with the name "MyWebsiteGroup", description "This is my website group", and parent group name "ParentGroup".

#>
Function New-LMWebsiteGroup {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$Properties,

        [Boolean]$DisableAlerting = $false,

        [boolean]$StopMonitoring = $false,

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
            $ParentGroupId = (Get-LMWebsiteGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
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
        $ResourcePath = "/website/groups"

        Try {
            $Data = @{
                name            = $Name
                description     = $Description
                disableAlerting = $DisableAlerting
                stopMonitoring  = $StopMonitoring
                properties      = $customProperties
                parentId        = $ParentGroupId
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.WebsiteGroup" )
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
