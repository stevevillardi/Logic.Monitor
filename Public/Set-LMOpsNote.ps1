Function Set-LMOpsNote {

    [CmdletBinding(DefaultParameterSetName = "All")]
    Param (
        [Parameter(Mandatory)]
        [String]$Id,

        [String]$Note,

        [Nullable[Datetime]]$NoteDate,

        [String[]]$Tags,

        [Switch]$ClearTags,

        [Parameter(ParameterSetName = 'Group')]
        [String[]]$DeviceGroupIds,

        [Parameter(ParameterSetName = 'Resource')]
        [String[]]$WebsiteIds, 

        [Parameter(ParameterSetName = 'Resource')]
        [String[]]$DeviceIds
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

        If($NoteDate){
            $Epoch = Get-Date -Date "01/01/1970"
            [int64]$NoteDate = (New-TimeSpan -Start $Epoch -End $NoteDate.ToUniversalTime()).TotalSeconds
        }

        $Scope = @()
        If($ResourceIds -or $WebsiteIds -or $DeviceGroupIds){
            Foreach($deviceId in $DeviceIds){
                $Scope += [PSCustomObject]@{
                    type = "device"
                    groupId = "0"
                    deviceId = $deviceId
                }
            }
            Foreach($websiteId in $WebsiteIds){
                $Scope += [PSCustomObject]@{
                    type = "website"
                    groupId = "0"
                    websiteId = $websiteId
                }
            }
            Foreach($groupId in $DeviceGroupIds){
                $Scope += @{
                    type = "deviceGroup"
                    groupId = $groupId
                }
            }
        }

        $TagList = @()
        Foreach($tag in $Tags){
            $TagList += @{name = $tag}
        }


        #Build header and uri
        $ResourcePath = "/setting/opsnotes/$Id"

        Try {
            $Data = @{
                happenOnInSec = $NoteDate
                note          = $Note
                tags          = $TagList
                scopes        = $Scope
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            If($ClearTags){
                $Data.tags = @()
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

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
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}