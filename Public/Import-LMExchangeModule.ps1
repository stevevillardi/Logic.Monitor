<#
.SYNOPSIS
Imports an LM Exchange module.

.DESCRIPTION
The Import-LMExchangeModule function is used to import an LM Exchange module into LogicMonitor.

.PARAMETER LMExchangeId
The LM Exchange module ID to import. This parameter is mandatory.

.EXAMPLE
Import-LMExchangeModule -LMExchangeId "LM12345"
Imports the LM Exchange module with the ID "LM12345" into LogicMonitor.
#>
Function Import-LMExchangeModule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$LMExchangeId
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/exchange/integrations/import"

            #Construct payload
            $Data = @{items = @()}
            $Data.items += [PSCustomObject]@{
                id = $LMExchangeId
            }

            $Data = ($Data | ConvertTo-Json)

            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return "Successfully imported LM Exchange module id: $LMExchangeId"

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