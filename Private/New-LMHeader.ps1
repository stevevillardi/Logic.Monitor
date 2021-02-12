Function New-LMHeader
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        $Auth,

        [Parameter(Mandatory)]
        [String]$Method,

        [Parameter(Mandatory)]
        [String]$ResourcePath,

        $Data,

        [Int]$Version = 3
    )

    # Use TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    # Get current time in milliseconds...
    $Epoch = [Math]::Round((New-TimeSpan -start (Get-Date -Date "1/1/1970") -end (Get-Date).ToUniversalTime()).TotalMilliseconds)

    # Concatenate general request details...
    If($Method -eq "GET" -or $Method -eq "DELETE"){
        $RequestVars = $Method + $Epoch + $ResourcePath
    }
    Else{
        $RequestVars = $Method + $Epoch + $Data + $ResourcePath
    }

    # Construct signature...
    $Hmac = New-Object System.Security.Cryptography.HMACSHA256
    $Hmac.Key = [Text.Encoding]::UTF8.GetBytes([System.Net.NetworkCredential]::new("", $Auth.Key).Password)

    $SignatureBytes = $Hmac.ComputeHash([Text.Encoding]::UTF8.GetBytes($RequestVars))
    $SignatureHex = [System.BitConverter]::ToString($SignatureBytes) -replace '-'
    $Signature = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($SignatureHex.ToLower()))

    # Construct headers...
    $LMAuth = 'LMv1 ' + $Auth.Id + ':' + $Signature + ':' + $Epoch
    $Header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Header.Add("Authorization",$LMAuth)
    $Header.Add("Content-Type",'application/json')
    $Header.Add("X-Version",$Version)

    Return $Header
}
