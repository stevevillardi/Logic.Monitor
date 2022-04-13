Function Import-LMRepositoryLogicModules {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [ValidateSet("datasources", "propertyrules", "eventsources", "topologysources", "configsources")]
        [String]$Type,

        [Int]$CoreVersion = 150,

        [Parameter(Mandatory)]
        [String[]]$LogicModuleNames

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/setting/$Type/importcore"

        #Initalize vars
        $Results = @()

        $Data = @{
            importDataSources = $LogicModuleNames
            coreserver        = "v$CoreVersion.core.logicmonitor.com"
            password          = "logicmonitor"
            username          = "anonymouse"
        }

        $Data = ($Data | ConvertTo-Json)

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data
            Write-LMHost "Modules imported successfully: $LogicModuleNames"
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
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
