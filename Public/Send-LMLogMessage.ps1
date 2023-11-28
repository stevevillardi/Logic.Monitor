Function Send-LMLogMessage {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory, ParameterSetName = 'SingleMessage')]
        [String]$Message,

        [Parameter(ParameterSetName = 'SingleMessage')]
        [String]$Timestamp,

        [Parameter(Mandatory, ParameterSetName = 'SingleMessage')]
        [Hashtable]$resourceMapping,
        
        [Parameter(ParameterSetName = 'SingleMessage')]
        [Hashtable]$Metadata,

        [Parameter(Mandatory, ParameterSetName = 'MessageList')]
        $MessageArray
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
                    
            #Build header and uri
            $ResourcePath = "/log/ingest"

            If (!$Timestamp) {
                $Timestamp = [DateTimeOffset]::UtcNow.ToUnixTimeMilliseconds()
            }

            Try {
                $Entries = @()

                #If sending single message, construct JSON object
                If ($Message) {                    
                    $Data = @{
                        message          = $Message
                        timestamp        = $Timestamp
                        '_lm.resourceId' = $resourceMapping
                    }
    
                    #Add additional hashtable of extra metadata
                    If ($Metadata) {
                        $Data += $Metadata
                    }
    
                    #Remove empty keys so we dont overwrite them
                    @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
                    $Entries += $Data
                    $Entries = ConvertTo-Json -InputObject $Entries
                }
                #We should have an array of messages so we need to add them to 
                Else {
                    $Entries = ConvertTo-Json -InputObject $MessageArray
                }

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Entries
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Entries

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Entries

                If ($Response.success -eq $true) {
                    Write-Output "Message accepted successfully @($Timestamp)"
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
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
