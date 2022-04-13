Function Get-LMCollectorDebugResult {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [Int]$SessionId,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup device name
            If ($Name) {
                If ($Name -Match "\*") {
                    Write-Error "Wildcard values not supported for collector names."
                    return
                }
                $Id = (Get-LMCollector -Name $Name | Select-Object -First 1 ).Id
                If (!$Id) {
                    Write-Error "Unable to find collector: $Name, please check spelling and try again."
                    return
                }
            }
            
            #Build header and uri
            $ResourcePath = "/debug/$SessionId"

            #Build query params
            $QueryParams = "?collectorId=$Id"

            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
            Return $Response
        }
        Else {
            Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}