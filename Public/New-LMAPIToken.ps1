Function New-LMAPIToken {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String[]]$Id,
        [Parameter(Mandatory, ParameterSetName = 'Username')]
        [String]$Username,
        [String]$Note,
        [Switch]$CreateDisabled
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Username) {
            If ($Username -Match "\*") {
                Write-Error "Wildcard values not supported for device group name." 
                return
            }
            $Id = (Get-LMUser -Name $Username | Select-Object -First 1 ).Id
            If (!$Id) {
                Write-Error "Unable to find device group with name: $Username, please check spelling and try again." 
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/setting/admins/$Id/apitokens"

        Try {
            $Data = @{
                note   = $Note
                status = $(If ($CreateDisabled) { 1 }Else { 2 })
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

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
