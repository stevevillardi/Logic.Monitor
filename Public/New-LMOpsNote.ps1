Function New-LMOpsNote {

    [CmdletBinding(DefaultParameterSetName = "All")]
    Param (
        [Parameter(Mandatory)]
        [String]$Note,

        [Datetime]$NoteDate,

        [String[]]$Tags,

        [Parameter(ParameterSetName = 'Group')]
        [String[]]$DeviceGroupIds,

        [Parameter(ParameterSetName = 'Resource')]
        [String[]]$WebsiteIds, 

        [Parameter(ParameterSetName = 'Resource')]
        [String[]]$DeviceIds
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If(!$NoteDate){
            [int64]$NoteDate = [DateTimeOffset]::Now.ToUnixTimeSeconds()
        }
        Else{
            $Epoch = Get-Date -Date "01/01/1970"
            [int64]$NoteDate = (New-TimeSpan -Start $Epoch -End $NoteDate.ToUniversalTime()).TotalSeconds
        }

        $Scope = @()
        If($ResourceIds -or $WebsiteIds -or $DeviceGroupIds){
            Foreach($id in $DeviceIds){
                $Scope += [PSCustomObject]@{
                    type = "device"
                    groupId = "0"
                    deviceId = $id
                }
            }
            Foreach($id in $WebsiteIds){
                $Scope += [PSCustomObject]@{
                    type = "website"
                    groupId = "0"
                    websiteId = $id
                }
            }
            Foreach($id in $DeviceGroupIds){
                $Scope += @{
                    type = "deviceGroup"
                    groupId = $id
                }
            }
        }

        $TagList = @()
        Foreach($tag in $Tags){
            $TagList += @{name = $tag}
        }


        #Build header and uri
        $ResourcePath = "/setting/opsnotes"

        Try {
            $Data = @{
                happenOnInSec = $NoteDate
                note          = $Note
                tags          = $TagList
                scopes        = $Scope
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

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
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
