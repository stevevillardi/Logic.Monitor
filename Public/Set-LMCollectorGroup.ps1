Function Set-LMCollectorGroup {

    [CmdletBinding()]
    Param (

        [Parameter(ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [Hashtable]$Properties,

        [Nullable[boolean]]$AutoBalance,

        [Nullable[Int]]$AutoBalanceInstanceCountThreshold

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        #Lookup Collector Name
        If ($Name) {
            $LookupResult = (Get-LMCollectorGroup -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        If ($Script:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/setting/collector/groups/$Id"

            Try {
                $Data = @{
                    description                         = $Description
                    name                                = $NewName
                    collectorGroupId                    = $CollectorGroupId
                    customProperties                    = $customProperties
                    autoBalance                         = $AutoBalance
                    autoBalanceInstanceCountThreshold   = $AutoBalanceInstanceCountThreshold
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.CollectorGroup" )
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
