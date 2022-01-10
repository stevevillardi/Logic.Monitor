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
        [String]$ParentGroupName,

        [String]$AppliesTo
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

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

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

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
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
