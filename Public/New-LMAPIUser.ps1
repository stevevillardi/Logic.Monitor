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
    If ($global:LMAuth.Valid) {

        #Build role id list
        $Roles = @()
        Foreach ($Role in $RoleNames) {
            $RoleId = (Get-LMRole -Name $Role | Select-Object -First 1 ).Id
            If ($RoleId) {
                $Roles += @{id = $RoleId }
            }
            Else {
                Write-Host "Unable to locate user role named $Role, it will be skipped" -ForegroundColor Yellow
            }
        }

        $AdminGroupIds = ""
        If ($UserGroups) {
            $AdminGroupIds = @()
            Foreach ($Group in $UserGroups) {
                If ($Group -Match "\*") {
                    Write-Host "Wildcard values not supported for groups." -ForegroundColor Yellow
                    return
                }
                $Id = (Get-LMUserGroup -Name $Group | Select-Object -First 1 ).Id
                If (!$Id) {
                    Write-Host "Unable to find user group: $Group, please check spelling and try again." -ForegroundColor Yellow
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
    }
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
