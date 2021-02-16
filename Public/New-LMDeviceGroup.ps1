Function New-LMDeviceGroup
{

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$GroupName,

        [String]$Description,

        [Hashtable]$Properties,

        [Boolean]$DisableAlerting = $false,

        [Boolean]$EnableNetFlow = $false,

        [Parameter(Mandatory,ParameterSetName = 'GroupId')]
        [Int]$ParentGroupId,

        [Parameter(Mandatory,ParameterSetName = 'GroupName')]
        [String]$ParentGroupName,

        [String]$AppliesTo
    )
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

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
        $ResourcePath = "/device/groups"

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
                defaultAutoBalancedCollectorGroupId = 0
                defaultCollectorGroupId = 0
                defaultCollectorId = 0
            }

            $Data = ($Data | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

            Return $Response
        }
        Catch [Exception] {
            $Exception = $PSItem
            Switch ($PSItem.Exception.GetType().FullName) {
                { "System.Net.WebException" -or "Microsoft.PowerShell.Commands.HttpResponseException" } {
                    $HttpException = ($Exception.ErrorDetails.Message | ConvertFrom-Json).errorMessage
                    $HttpStatusCode = $Exception.Exception.Response.StatusCode.value__
                    Write-Error "Failed to execute web request($($HttpStatusCode)): $HttpException"
                }
                default {
                    $LMError = $Exception.ToString()
                    Write-Error "Failed to execute web request: $LMError"
                }
            }
            Return
        }
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
