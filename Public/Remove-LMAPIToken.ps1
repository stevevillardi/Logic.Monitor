Function Remove-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$UserId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$UserName,

        [Parameter(Mandatory)]
        [Int]$APITokenId

    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

        #Lookup UserName Id if supplying username
        If ($UserName) {
            $LookupResult = (Get-LMUser -Name $UserName).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $UserName) {
                return
            }
            $UserId = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/setting/admins/$UserId/apitokens/$APITokenId"

        Try {
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers
            Write-LMHost "Successfully removed id ($APITokenId)" -ForegroundColor Green
            
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
