Function Remove-LMUser {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($global:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                If ($Name -Match "\*") {
                    Write-Host "Wildcard values not supported for username." -ForegroundColor Yellow
                    return
                }
                $Id = (Get-LMUser -Name $Name | Select-Object -First 1 ).Id
                If (!$Id) {
                    Write-Host "Unable to find username: $Name, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }
            
            #Build header and uri
            $ResourcePath = "/setting/admins/$Id"

            #Loop through requests 
            Try {
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers
                Write-Host "Successfully removed id ($Id)" -ForegroundColor Green

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
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
