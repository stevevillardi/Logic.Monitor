<#
.SYNOPSIS
    Invokes a session logoff for one or more users in Logic Monitor.

.DESCRIPTION
    The Invoke-LMUserLogoff function is used to log off one or more users from a Logic Monitor session. It checks if the user is logged in and has valid API credentials before making the logoff request. If the user is not logged in, an error message is displayed.

.PARAMETER Usernames
    Specifies an array of usernames for which the session logoff needs to be invoked.

.EXAMPLE
    Invoke-LMUserLogoff -Usernames "user1", "user2"
    Invokes a session logoff for the users "user1" and "user2" in Logic Monitor.

#>
Function Invoke-LMUserLogoff {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String[]]$Usernames
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/setting/admins/services/logoffUsers"

            $Data = @{
                userNames = $Usernames
            }

            $Data = ($Data | ConvertTo-Json)
            
            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return "Invoke session logoff for username(s): $($Usernames -Join ",")."
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
