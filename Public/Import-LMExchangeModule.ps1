Function Import-LMExchangeModule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$LMExchangeId
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($global:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/exchange/integrations/import"

            #Construct payload
            $Data = @{items = @()}
            $Data.items += [PSCustomObject]@{
                id = $LMExchangeId
            }

            $Data = ($Data | ConvertTo-Json)

            Try {

                $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data
                Write-LMHost "Successfully imported LM Exchange module id: $LMExchangeId"

                Return

            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}