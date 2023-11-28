Function Import-LMRepositoryLogicModules {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateSet("datasources", "propertyrules", "eventsources", "topologysources", "configsources")]
        [String]$Type,

        [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
        [Alias('Name')]
        [String[]]$LogicModuleNames

    )
    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {
                
            #Build header and uri
            $ResourcePath = "/setting/$Type/importcore"

            #Initalize vars
            $Results = @()

            $Data = @{
                importDataSources = $LogicModuleNames
                coreserver        = "core.logicmonitor.com"
                password          = "logicmonitor"
                username          = "anonymouse"
            }

            $Data = ($Data | ConvertTo-Json)

            Try {
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return "Modules imported successfully: $LogicModuleNames"
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
            Return 
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End{}
}
