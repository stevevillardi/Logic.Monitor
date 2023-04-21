Function Set-LMDatasource {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$DisplayName,

        [String]$Description,

        [String]$TechNotes,

        [String]$PollingIntervalInSeconds, #In Seconds

        [PSCustomObject]$Datapoints #Should be the full datapoints object from the output of Get-LMDatasource

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup ParentGroupName
            If ($Name) {
                $LookupResult = (Get-LMDatasource -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
                    
            #Build header and uri
            $ResourcePath = "/setting/datasources/$Id"

            Try {
                $Data = @{
                    name                      = $NewName
                    displayName               = $DisplayName
                    description               = $Description
                    appliesTo                 = $appliesTo
                    technology                = $TechNotes
                    collectInterval           = $PollingIntervalInSeconds
                    dataPoints                = $Datapoints
                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?forceUniqueIdentifier=true"

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Datasource" )
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
