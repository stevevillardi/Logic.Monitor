Function Get-LMTopologyMapData {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

        #Lookup Id if supplying name
        If ($Name) {
            If ($Name -Match "\*") {
                Write-Host "Wildcard values not supported for topology map name." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMTopologyMap -Name $Name | Select-Object -First 1).Id

            If (!$Id) {
                Write-Host "Unable to find topology map: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/topology/topologies/$Id/data"

        #Loop through requests 
        While (!$Done) {
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
        }
        Return $Results
    }
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
