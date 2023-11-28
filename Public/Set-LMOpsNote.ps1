Function Set-LMOpsNote {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [String]$Note,

        [Nullable[Datetime]]$NoteDate,

        [String[]]$Tags,

        [Switch]$ClearTags,

        [String[]]$DeviceGroupIds,

        [String[]]$WebsiteIds, 

        [String[]]$DeviceIds
    )

    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

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
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }

                If($ClearTags){
                    $Data.tags = @()
                }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
    End{}
}
