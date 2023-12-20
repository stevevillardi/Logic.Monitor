Function Set-LMDeviceGroup {

    [CmdletBinding(DefaultParameterSetName = "Id-ParentGroupId",SupportsShouldProcess,ConfirmImpact='None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupId', ValueFromPipelineByPropertyName)]
        [Parameter(Mandatory, ParameterSetName = 'Id-ParentGroupName')]
        [String]$Id,
        
        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupId')]
        [Parameter(Mandatory, ParameterSetName = 'Name-ParentGroupName')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [Hashtable]$Properties,

        [ValidateSet("Add", "Replace", "Refresh")] # Add will append to existing prop, Replace will update existing props if specified and add new props, refresh will replace existing props with new
        [String]$PropertiesMethod = "Replace",

        [Nullable[boolean]]$DisableAlerting,

        [Nullable[boolean]]$EnableNetFlow,

        [String]$AppliesTo,

        [Parameter(ParameterSetName = 'Id-ParentGroupId')]
        [Parameter(ParameterSetName = 'Name-ParentGroupId')]
        [Nullable[Int]]$ParentGroupId,

        [Parameter(ParameterSetName = 'Id-ParentGroupName')]
        [Parameter(ParameterSetName = 'Name-ParentGroupName')]
        [String]$ParentGroupName
    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Group Id
            If ($Name) {
                $LookupResult = (Get-LMDeviceGroup -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }

            #Lookup ParentGroupId
            If ($ParentGroupName) {
                $LookupResult = (Get-LMDeviceGroup -Name $ParentGroupName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $ParentGroupName) {
                    return
                }
                $ParentGroupId = $LookupResult
            }

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/device/groups/$Id"

            If($PSItem){
                $Message = "Id: $Id | Name: $($PSItem.name) | Path: $($PSItem.fullPath)"
            }
            ElseIf($Name){
                $Message = "Id: $Id | Name: $Name)"
            }
            Else{
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    name             = $NewName
                    description      = $Description
                    appliesTo        = $AppliesTo
                    disableAlerting  = $DisableAlerting
                    enableNetflow    = $EnableNetFlow
                    customProperties = $customProperties
                    parentId         = $ParentGroupId
                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)

                If ($PSCmdlet.ShouldProcess($Message, "Set Device Group")) { 
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?opType=$($PropertiesMethod.ToLower())"

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.DeviceGroup" )
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
