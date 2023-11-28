Function Get-LMRepositoryLogicModules {

    [CmdletBinding()]
    Param (
        [ValidateSet("datasource", "propertyrules", "eventsource", "topologysource", "configsource")]
        [String]$Type = "datasource"

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/logicmodules/listcore"

        #Initalize vars
        $QueryParams = "?type=$Type"
        $Results = @()

        $Data = @{
            coreServer = "core.logicmonitor.com"
            password   = "logicmonitor"
            username   = "anonymouse"
        }

        $Data = ($Data | ConvertTo-Json)

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
                
            
                
            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
            $Results = $Response.Items
        }
        Catch [Exception] {
            $Proceed = Resolve-LMException -LMException $PSItem
            If (!$Proceed) {
                Return
            }
        }
        Return (Add-ObjectTypeInfo -InputObject $Results -TypeName "LogicMonitor.RepositoryLogicModules" )
    }
    Else {
        Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
    }
}
