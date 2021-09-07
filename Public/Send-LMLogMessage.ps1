Function Send-LMLogMessage {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Message,

        [String]$Timestamp,

        [Parameter(Mandatory)]
        [Hashtable]$resourceId,
        
        [Hashtable]$Metadata
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($global:LMAuth.Valid) {
                    
            #Build header and uri
            $ResourcePath = "/log/ingest"

            If (!$Timestamp) {
                $Timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
            }

            Try {
                $Entries = @()
                $Data = @{
                    message          = $Message
                    timestamp        = $Timestamp
                    '_lm.resourceId' = $resourceId
                }

                #Add additional hashtable of extra metadata
                $Data += $Metadata

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
                $Entries += $Data
                $Entries = ConvertTo-Json -InputObject $Entries

                $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Entries
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Entries

                If ($Response.success -eq $true) {
                    Write-Verbose "Message accepted successfully"
                }
                Else {
                    Write-Error -Message "$($Response.errors.code): $($Response.errors.error)"
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
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
