Function New-LMAlertNote {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String[]]$Ids,
        [Parameter(Mandatory)]
        [String]$Note
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {
        
        #Build header and uri
        $ResourcePath = "/alerts/notes"

        Try {
            $allIds = @()

            Foreach ($Id in $Ids) {
                $allIds += @{model = "alerts"; id = $Id }
            }

            $Data = @{
                data = @{allIds = $allIds}
                meta  = @{notes = $Note}
            }

            $Data = ($Data | ConvertTo-Json -Depth 3)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data -Version 4
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

            If(!$Response.data -and !$Response.errors){
                Write-Error "Unable to acknowledge alerts. Verify your parameters and try again"
            }
            Else{
                If($Response.data){
                    Foreach($item in $Response.data.allIds){
                        Write-LMHost "Successfully added note for alert id: $($item.id)" -ForegroundColor Green
                    }
                }
                If($Response.errors){
                    $ResponseErrors = Get-LMv4AlertError -InputObject $Response.errors
                    Foreach ($Err in $ResponseErrors) {
                        Write-Error $Err
                    }
                }
            }
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
