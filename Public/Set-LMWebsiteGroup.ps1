Function Set-LMWebsiteGroup {

    [CmdletBinding(DefaultParameterSetName = 'Id-ParentGroupId')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupName', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupName')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [Hashtable]$Properties,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$StopMonitoring,

        #Need to implement testLocation

        [Parameter(ParameterSetName = 'Id-ParentGroupId')]
        [Parameter(ParameterSetName = 'Name-ParentGroupId')]
        [Nullable[Int]]$ParentGroupId,
        
        [Parameter(ParameterSetName = 'Id-ParentGroupName')]
        [Parameter(ParameterSetName = 'Name-ParentGroupName')]
        [String]$ParentGroupName
    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup ParentGroupName
            If ($Name) {
                $LookupResult = (Get-LMWebsiteGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

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
            $ResourcePath = "/website/groups/$Id"

            Try {
                $Data = @{
                    name            = $NewName
                    description     = $Description
                    disableAlerting = $DisableAlerting
                    stopMonitoring  = $StopMonitoring
                    properties      = $customProperties
                    parentId        = $ParentGroupId
                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
    End {}
}
