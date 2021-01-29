Function Set-LMDeviceGroup
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'GroupId')]
        [String]$GroupId,

        [Parameter(Mandatory,ParameterSetName = 'GroupName')]
        [String]$GroupName,

        [String]$Description,

        [Hashtable]$Properties,

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [String]$AppliesTo,

        [Parameter(ParameterSetName = 'ParentGroupId')]
        [Int]$ParentGroupId,

        [Parameter(ParameterSetName = 'ParentGroupName')]
        [String]$ParentGroupName
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        #Lookup ParentGroupName
        If($GroupName){
            If($GroupName -Match "\*"){
                Write-Host "Wildcard values not supported for groups names." -ForegroundColor Yellow
                return
            }
            $GroupId = (Get-LMDeviceGroup -Name $GroupName | Select-Object -First 1 ).Id
            If(!$GroupId){
                Write-Host "Unable to find group: $GroupName, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }

        #Lookup ParentGroupName
        If($ParentGroupName){
            If($ParentGroupName -Match "\*"){
                Write-Host "Wildcard values not supported for groups names." -ForegroundColor Yellow
                return
            }
            $ParentGroupId = (Get-LMDeviceGroup -Name $ParentGroupName | Select-Object -First 1 ).Id
            If(!$ParentGroupId){
                Write-Host "Unable to find group: $ParentGroupName, please check spelling and try again." -ForegroundColor Yellow
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
        $ResourcePath = "/device/groups/$GroupId"

        #Loop through requests 
        Try{
            $Data = @{
                name = $GroupName
                description = $Description
                appliesTo = $AppliesTo
                disableAlerting = $DisableAlerting
                enableNetflow = $EnableNetFlow
                customProperties =  $customProperties
                parentId = $ParentGroupId
            }

            
            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if (-not $Data[$_]) { $Data.Remove($_) } }
            
            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

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
