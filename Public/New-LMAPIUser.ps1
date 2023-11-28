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
