Function Connect-LMAccount
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$AccessId,

        [Parameter(Mandatory)]
        [String]$AccessKey,

        [Parameter(Mandatory)]
        [String]$AccountName
    )
    
    #Convert to secure string
    [SecureString]$AccessKey = $AccessKey | ConvertTo-SecureString -AsPlainText -Force

    #Create Credential Object for reuse in other functions
    $global:LMAuth = [PSCustomObject]@{
        Id      = $AccessId
        Key     = $AccessKey
        Portal  = $AccountName
        Valid   = $false
    }

    Try {
        #Build header and uri
        $ResourcePath = "/setting/companySetting"
        $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
        $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

        #Issue request
        $Request = Invoke-WebRequest -Uri $Uri -Method "GET" -Headers $Headers
        $Response = $Request.Content | ConvertFrom-Json
        Write-Host "Connected to LM portal $($Response.companyDisplayName) using account $($Response.name) - ($($Response.numberOfDevices) devices)." -ForegroundColor Green
        
        #Set valid flag so we dont prompt for auth details on future requests
        $global:LMAuth.Valid = $true
    }
    Catch {
        Write-Error "Unable to login to account, please ensure your access info and account name are correct: $($_.Exception.Message)"
        #Clear credential object from environment
        Remove-Variable LMAuth -Scope Global
    }
}
