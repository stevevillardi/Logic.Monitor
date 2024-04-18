<#
.SYNOPSIS
Creates a new LogicMonitor OpsNote.

.DESCRIPTION
The New-LMOpsNote function is used to create a new OpsNote in LogicMonitor. OpsNotes are used to document important information or events related to monitoring.

.PARAMETER Note
Specifies the content of the OpsNote. This parameter is mandatory.

.PARAMETER NoteDate
Specifies the date and time of the OpsNote. If not provided, the current date and time will be used.

.PARAMETER Tags
Specifies an array of tags to associate with the OpsNote.

.PARAMETER DeviceGroupIds
Specifies an array of device group IDs to associate with the OpsNote.

.PARAMETER WebsiteIds
Specifies an array of website IDs to associate with the OpsNote.

.PARAMETER DeviceIds
Specifies an array of device IDs to associate with the OpsNote.

.EXAMPLE
New-LMOpsNote -Note "Server maintenance scheduled for tomorrow" -NoteDate (Get-Date).AddDays(1) -Tags "maintenance", "server"

This example creates a new OpsNote with the content "Server maintenance scheduled for tomorrow" and a note date set to tomorrow. It also associates the tags "maintenance" and "server" with the OpsNote.

.NOTES
LogicMonitor API credentials must be set before using this function. Use the Connect-LMAccount function to log in and set the credentials.
#>
Function New-LMOpsNote {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Note,

        [Datetime]$NoteDate,

        [String[]]$Tags,

        [String[]]$DeviceGroupIds,

        [String[]]$WebsiteIds, 

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
