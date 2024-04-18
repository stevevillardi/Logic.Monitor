<#
.SYNOPSIS
Creates a new LogicMonitor Applies To function.

.DESCRIPTION
The New-LMAppliesToFunction function is used to create a new LogicMonitor Applies To function. It requires the name and applies to parameters, and optionally accepts a description parameter. The function checks if the user is logged in and has valid API credentials before making the API call to create the function.

.PARAMETER Name
The name of the LogicMonitor Applies To function. This parameter is mandatory.

.PARAMETER Description
The description of the LogicMonitor Applies To function. This parameter is optional.

.PARAMETER AppliesTo
The code that defines the LogicMonitor Applies To function. This parameter is mandatory.

.EXAMPLE
New-LMAppliesToFunction -Name "MyFunction" -AppliesTo "isWindows() && isLinux()"

This example creates a new LogicMonitor Applies To function with the name "MyFunction" and the code "return true".
#>
Function New-LMAppliesToFunction {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Parameter(Mandatory)]
        [String]$AppliesTo

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        
        #Build header and uri
        $ResourcePath = "/setting/functions"

        Try {
            $Data = @{
                name                                = $Name
                description                         = $Description
                code                                = $AppliesTo
            }

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
