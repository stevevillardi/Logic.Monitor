<#
.SYNOPSIS
Sends log messages to LogicMonitor.

.DESCRIPTION
The Send-LMLogMessage function sends log messages to LogicMonitor for logging and monitoring purposes. It supports sending a single message or an array of messages.

.PARAMETER Message
Specifies the log message to send. This parameter is mandatory when using the 'SingleMessage' parameter set.

.PARAMETER Timestamp
Specifies the timestamp for the log message. If not provided, the current UTC timestamp will be used. This parameter is mandatory when using the 'SingleMessage' parameter set.

.PARAMETER resourceMapping
Specifies the resource mapping for the log message. This parameter is mandatory when using the 'SingleMessage' parameter set.

.PARAMETER Metadata
Specifies additional metadata to include with the log message. This parameter is optional when using the 'SingleMessage' parameter set.

.PARAMETER MessageArray
Specifies an array of log messages to send. This parameter is mandatory when using the 'MessageList' parameter set.

.EXAMPLE
Send-LMLogMessage -Message "This is a test log message" -resourceMapping @{ 'system.deviceId' = '12345' } -Metadata @{ 'key1' = 'value1'; 'key2' = 'value2' }

Sends a single log message with the specified message, resource mapping, and metadata.

.EXAMPLE
Send-LMLogMessage -MessageArray $MessageObjectsArray

Sends an array of log message objects.

#>
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
