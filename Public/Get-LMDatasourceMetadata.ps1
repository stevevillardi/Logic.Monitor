Function Get-LMDatasourceMetadata {

    [CmdletBinding(DefaultParameterSetName = 'All')]
    Param (
        [Parameter(ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(ParameterSetName = 'DisplayName')]
        [String]$DisplayName,

        [Int]$BatchSize = 1000
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

        #Lookup Name
        If ($Name) {
            $LookupResult = (Get-LMDatasource -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        #Lookup DisplayName
        If ($DisplayName) {
            $LookupResult = (Get-LMDatasource -DisplayName $DisplayName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $DisplayName) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/setting/registry/metadata/datasource/$Id"

        #Initalize vars
        $QueryParams = ""

            #Build query params
            $QueryParams = "?size=$BatchSize&offset=$Count&sort=+id"

            Try {
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams
    
                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers

                Return $Response

            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        Return $Results
    }
    Else {
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
