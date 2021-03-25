<#
.SYNOPSIS
Connect to a specified LM portal to run commands against

.DESCRIPTION
Connect to a specified LM portal which will allow you run the other LM commands assoicated with the Logic.Monitor PS module. Used in conjunction with Disconnect-LMAccount to close a session previously connected via Connect-LMAccount

.PARAMETER AccessId
Access ID from your API credential aquired from the LM Portal

.PARAMETER AccessKey
Access Key from your API credential aquired from the LM Portal

.PARAMETER AccountName
The subdomain for your LM portal, the name before ".logicmonitor.com" (subdomain.logicmonitor.com)

.EXAMPLE
Connect-LMAccount -AccessId xxxxxx -AccessKey xxxxxx -AccountName subdomain

.NOTES
You must run this command before you will be able to execute other commands included with the Logic.Monitor module.
#>
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
        #Set valid flag so we dont prompt for auth details on future requests
        $global:LMAuth.Valid = $true

        #Collect portal info and api username and roles
        $ApiInfo = Get-LMAPIToken -Filter @{accessId=$AccessId} -ErrorAction Stop
        $PortalInfo = Get-LMPortalInfo -ErrorAction Stop

        Write-Host "Connected to LM portal $($PortalInfo.companyDisplayName) using account $($ApiInfo.adminName) with assgined roles: $($ApiInfo.roles -join ",") - ($($PortalInfo.numberOfDevices) devices | $($PortalInfo.numOfWebsites) websites)." -ForegroundColor Green
        
        return $Response
    }
    Catch {
        Write-Error "Unable to login to account, please ensure your access info and account name are correct: $($_.Exception.Message)"
        #Clear credential object from environment
        Remove-Variable LMAuth -Scope Global
        Return
    }
}
