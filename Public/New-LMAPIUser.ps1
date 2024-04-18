<#
.SYNOPSIS
Creates a new LogicMonitor API user.

.DESCRIPTION
The New-LMAPIUser function is used to create a new LogicMonitor API user. It requires a username and supports optional parameters such as user groups, a note, role names, and status.

.PARAMETER Username
Specifies the username for the new API user. This parameter is mandatory.

.PARAMETER UserGroups
Specifies an array of user groups to which the new API user should be added. This parameter is optional.

.PARAMETER Note
Specifies a note for the new API user. This parameter is optional.

.PARAMETER RoleNames
Specifies an array of role names for the new API user. The default value is "readonly". This parameter is optional.

.PARAMETER Status
Specifies the status of the new API user. Valid values are "active" and "suspended". The default value is "active". This parameter is optional.

.EXAMPLE
New-LMAPIUser -Username "john.doe" -UserGroups @("Group1","Group2") -Note "Test user" -RoleNames "admin" -Status "active"

This example creates a new API user with the username "john.doe", adds the user to "Group1" and "Group2" user groups, adds a note "Test user", assigns the "admin" role, and sets the status to "active".

.NOTES
This function requires a valid API session. Make sure to log in using the Connect-LMAccount function before running this command.
#>
Function New-LMAPIUser {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Username,

        [String[]]$UserGroups,

        [String]$Note,

        [String[]]$RoleNames = @("readonly"),

        [ValidateSet("active", "suspended")]
        [String]$Status = "active"
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Build role id list
        $Roles = @()
        Foreach ($Role in $RoleNames) {
            $RoleId = (Get-LMRole -Name $Role | Select-Object -First 1 ).Id
            If ($RoleId) {
                $Roles += @{id = $RoleId }
            }
            Else {
                Write-LMHost "[WARN]: Unable to locate user role named $Role, it will be skipped" -ForegroundColor Yellow
            }
        }

        $AdminGroupIds = ""
        If ($UserGroups) {
            $AdminGroupIds = @()
            Foreach ($Group in $UserGroups) {
                If ($Group -Match "\*") {
                    Write-Error "Wildcard values not supported for groups." 
                    return
                }
                $Id = (Get-LMUserGroup -Name $Group | Select-Object -First 1 ).Id
                If (!$Id) {
                    Write-Error "Unable to find user group: $Group, please check spelling and try again." 
                    return
                }
                $AdminGroupIds += $Id
            }
        }

        
        #Build header and uri
        $ResourcePath = "/setting/admins"

        #Loop through requests 
        $Done = $false
        While (!$Done) {
            Try {
                $Data = @{
                    username      = $Username
                    note          = $Note
                    roles         = $Roles
                    status        = $Status
                    adminGroupIds = $AdminGroupIds
                    apionly       = $true

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
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
