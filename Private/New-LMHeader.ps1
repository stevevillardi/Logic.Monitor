
<#
.SYNOPSIS
    Creates a header for LogicMonitor API requests.

.DESCRIPTION
    The New-LMHeader function is used to create a header for LogicMonitor API requests. It supports various authentication methods and constructs the necessary headers based on the provided parameters.

.PARAMETER Auth
    Specifies the authentication details for the API request. It can be either a Bearer token, a session synchronization object, or an API key.

.PARAMETER Method
    Specifies the HTTP method for the API request (e.g., GET, POST, PUT, DELETE).

.PARAMETER ResourcePath
    Specifies the resource path for the API request.

.PARAMETER Data
    Specifies the data payload for the API request. This parameter is optional and only required for certain HTTP methods.

.PARAMETER Version
    Specifies the API version to use. The default value is 3.

.PARAMETER ContentType
    Specifies the content type of the API request. The default value is "application/json".

.OUTPUTS
    Returns an array containing the constructed header and a web request session object.

.EXAMPLE
    $auth = @{
        Type = "Bearer"
        BearerToken = "your_bearer_token"
    }
    $header, $session = New-LMHeader -Auth $auth -Method "GET" -ResourcePath "/api/devices"

    # Use the $header and $session objects for making LogicMonitor API requests.
#>

Function New-LMHeader {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        $Auth,

        [Parameter(Mandatory)]
        [String]$Method,

        [Parameter(Mandatory)]
        [String]$ResourcePath,

        $Data,

        [Int]$Version = 3,

        [String]$ContentType = "application/json"
    )

    # Use TLS 1.2
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

    $Header = New-Object "System.Collections.Generic.Dictionary[[String],[String]]"
    $Session = New-Object Microsoft.PowerShell.Commands.WebRequestSession

    If($Auth.Type -eq "Bearer"){
        $Token = [System.Net.NetworkCredential]::new("", $Auth.BearerToken).Password
        $Header.Add("Authorization", "Bearer $Token")
    }
    ElseIf($Auth.Type -eq "SessionSync"){
        $SessionInfo = Get-LMSession -AccountName $Auth.Portal
        If($SessionInfo){
            $Header.Add("Cookie", "JSESSIONID=$($SessionInfo.jSessionID)")
            $Session.Cookies.Add((New-Object System.Net.Cookie("JSESSIONID", $SessionInfo.jSessionID, "/", $SessionInfo.domain)))
            $Header.Add("X-CSRF-Token", "$($SessionInfo.token)")
        }
        Else{
            throw "Unable to generate header details, ensure you are connected to a portal and try again."
        }
    }
    Else{
        # Get current time in milliseconds...
        $Epoch = [Math]::Round((New-TimeSpan -start (Get-Date -Date "1/1/1970") -end (Get-Date).ToUniversalTime()).TotalMilliseconds)

        # Concatenate general request details...
        If ($Method -eq "GET" -or $Method -eq "DELETE") {
            $RequestVars = $Method + $Epoch + $ResourcePath
        }
        Else {
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
        $Header.Add("Authorization", $LMAuth)
    }

    $Header.Add("Content-Type", $ContentType)
    $Header.Add("X-Version", $Version)

    Return @($Header,$Session)
}
