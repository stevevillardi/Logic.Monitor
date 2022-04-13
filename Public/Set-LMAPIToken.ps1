Function Set-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$UserId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$UserName,

        [Parameter(Mandatory)]
        [Int]$APITokenId,

        [String]$Note,

        [ValidateSet("active", "suspended")]
        [String]$Status

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup Id if supplying username
        If ($Username) {
            $LookupResult = (Get-LMUser -Name $Username).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Username) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/setting/admins/$UserId/apitokens/$APITokenId"

        Try {
            $Data = @{
                note   = $Note
                status = $Status
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if (-not $Data[$_]) { $Data.Remove($_) } }

            If ($Status) {
                $Data.status = $(If ($Status -eq "active") { 2 }Else { 1 })
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data

            Return $Response
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
