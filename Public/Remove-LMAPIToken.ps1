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

        #Lookup Id if supplying username
        If ($UserName) {
            If ($Name -Match "\*") {
                Write-Host "Wildcard values not supported for username." -ForegroundColor Yellow
                return
            }
            $UserId = (Get-LMUser -Name $UserName | Select-Object -First 1 ).Id
            If (!$UserId) {
                Write-Host "Unable to find username: $UserName, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/setting/admins/$UserId/apitokens/$APITokenId"

        #Loop through requests 
        $Done = $false
        While (!$Done) {
            Try {
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers
                Write-Host "Successfully removed id ($Id)" -ForegroundColor Green
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
    }
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
