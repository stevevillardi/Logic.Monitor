<#
.SYNOPSIS
Creates a new LogicMonitor API token.

.DESCRIPTION
The New-LMAPIToken function is used to create a new LogicMonitor API token. It requires the user to be logged in and have valid API credentials. The function supports two parameter sets: 'Id' and 'Username'. The 'Id' parameter set is used to specify the user ID for which the API token will be created. The 'Username' parameter set is used to specify the username for which the API token will be created. The function also supports additional parameters such as 'Note', 'CreateDisabled', and 'Type'.

.PARAMETER Id
Specifies the user ID for which the API token will be created. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Username
Specifies the username for which the API token will be created. This parameter is mandatory when using the 'Username' parameter set.

.PARAMETER Note
Specifies a note for the API token.

.PARAMETER CreateDisabled
Specifies whether the API token should be created in a disabled state.

.PARAMETER Type
Specifies the type of API token to create. Valid values are 'LMv1' and 'Bearer'. The default value is 'LMv1'.

.EXAMPLE
New-LMAPIToken -Id "12345" -Note "API Token for user 12345"

.EXAMPLE
New-LMAPIToken -Username "john.doe" -Note "API Token for user john.doe" -CreateDisabled

.NOTES
This function requires the user to be logged in and have valid API credentials. Use the Connect-LMAccount function to log in before running any commands.
#>

Function New-LMAPIToken {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String[]]$Id,
        [Parameter(Mandatory, ParameterSetName = 'Username')]
        [String]$Username,
        [String]$Note,
        [Switch]$CreateDisabled,
        [ValidateSet("LMv1", "Bearer")]
        [String]$Type = "LMv1"
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Username) {
            If ($Username -Match "\*") {
                Write-Error "Wildcard values not supported for device group name." 
                return
            }
            $Id = (Get-LMUser -Name $Username | Select-Object -First 1 ).Id
            If (!$Id) {
                Write-Error "Unable to find user with name: $Username, please check spelling and try again." 
                return
            }
        }
        
        #Build header and uri
        If($Type -eq "Bearer"){
            $Params = "?type=bearer"
        }

        $ResourcePath = "/setting/admins/$Id/apitokens"

        Try {
            $Data = @{
                note   = $Note
                status = $(If ($CreateDisabled) { 1 }Else { 2 })
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $Params

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.APIToken" )
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
