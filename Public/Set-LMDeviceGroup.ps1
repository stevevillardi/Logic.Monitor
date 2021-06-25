Function Set-LMDeviceGroup {

    [CmdletBinding(DefaultParameterSetName = "Id-ParentGroupId")]
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

        [Nullable[boolean]]$EnableNetFlow,

        [String]$AppliesTo,

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
        If ($global:LMAuth.Valid) {

            #Lookup ParentGroupName
            If ($Name -and !$Id) {
                If ($Name -Match "\*") {
                    Write-Host "Wildcard values not supported for groups names." -ForegroundColor Yellow
                    return
                }
                $Id = (Get-LMDeviceGroup -Name $Name | Select-Object -First 1 ).Id
                If (!$Id) {
                    Write-Host "Unable to find group: $Name, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }

            #Lookup ParentGroupName
            If ($ParentGroupName) {
                If ($ParentGroupName -Match "\*") {
                    Write-Host "Wildcard values not supported for groups names." -ForegroundColor Yellow
                    return
                }
                $ParentGroupId = (Get-LMDeviceGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
                If (!$ParentGroupId) {
                    Write-Host "Unable to find group: $ParentGroupName, please check spelling and try again." -ForegroundColor Yellow
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
            $ResourcePath = "/device/groups/$Id"

            #Loop through requests 
            $Done = $false
            While (!$Done) {
                Try {
                    $Data = @{
                        name             = $NewName
                        description      = $Description
                        appliesTo        = $AppliesTo
                        disableAlerting  = $DisableAlerting
                        enableNetflow    = $EnableNetFlow
                        customProperties = $customProperties
                        parentId         = $ParentGroupId
                    }

                    #Remove empty keys so we dont overwrite them
                    @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
                
                    $Data = ($Data | ConvertTo-Json)

                    $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data

                    Return $Response
                }
                Catch [Exception] {
                    $Proceed = Resolve-LMException -LMException $PSItem
                    If (!$Proceed) {
                        Return
                    }
                }
            }
        }
        Else {
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
