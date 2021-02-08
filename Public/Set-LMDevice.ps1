Function Set-LMDevice
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'Id',ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory,ParameterSetName = 'Name')]
        [String]$Name,

        [String]$DisplayName,

        [String]$Description,

        [String]$PreferredCollectorId,

        [String]$PreferredCollectorGroupId,

        [Hashtable]$Properties,

        [String[]]$HostGroupIds, #Dynamic group ids will be ignored, operation will replace all existing groups

        [ValidateSet("Add","Replace","Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [String]$Link,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [String]$NetflowCollectorGroupId,

        [String]$NetflowCollectorId
    )
    #Check if we are logged in and have valid api creds
    Begin{}
    Process{
        If($global:LMAuth.Valid){

            #Lookup ParentGroupName
            If($Name -and !$Id){
                If($Name -Match "\*"){
                    Write-Host "Wildcard values not supported for device names." -ForegroundColor Yellow
                    return
                }
                $Id = (Get-LMDevice -Name $Name | Select-Object -First 1 ).Id
                If(!$Id){
                    Write-Host "Unable to find device: $Name, please check spelling and try again." -ForegroundColor Yellow
                    return
                }
            }

            #Build custom props hashtable
            $customProperties = @()
            If($Properties){
                Foreach($Key in $Properties.Keys){
                    $customProperties += @{name=$Key;value=$Properties[$Key]}
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/device/devices/$Id"

            #Loop through requests 
            Try{
                $Data = @{
                    name = $Name
                    displayName = $DisplayName
                    description = $Description
                    disableAlerting = $DisableAlerting
                    enableNetflow = $EnableNetFlow
                    customProperties =  $customProperties
                    preferredCollectorId = $PreferredCollectorId
                    preferredCollectorGroupId = $PreferredCollectorGroupId
                    link = $Link
                    netflowCollectorGroupId = $NetflowCollectorGroupId
                    netflowCollectorId = $NetflowCollectorId
                    hostGroupIds = $HostGroupIds -join ","
                }

                
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
                
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                #Issue request
                $Request = Invoke-WebRequest -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data
                $Response = $Request.Content | ConvertFrom-Json

                Return $Response
            }
            Catch [Microsoft.PowerShell.Commands.HttpResponseException] {
                $HttpException = ($PSItem.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                $HttpStatusCode = $PSItem.Exception.Response.StatusCode.value__
                Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
            }
            Catch{
                $LMError = $PSItem.ToString()
                Write-Error "Failed to execute web request: $LMError"
            }
        }
        Else{
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}
