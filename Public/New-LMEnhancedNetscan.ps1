<#
.SYNOPSIS
Creates a new enhanced network scan in LogicMonitor.

.DESCRIPTION
The New-LMEnhancedNetScan function creates a new enhanced network scan in LogicMonitor. It allows you to specify various parameters such as the collector ID, name, net scan group name, custom credentials, filters, description, exclude duplicate type, method, next start, next start epoch, Groovy script, credential group ID, and credential group name.

.PARAMETER CollectorId
The ID of the collector where the network scan will be executed.

.PARAMETER Name
The name of the network scan.

.PARAMETER NetScanGroupName
The name of the net scan group.

.PARAMETER CustomCredentials
A list of custom credentials to be used for the network scan.

.PARAMETER Filters
A list of filters to be applied to the network scan.

.PARAMETER Description
A description of the network scan.

.PARAMETER ExcludeDuplicateType
The type of duplicates to be excluded. Default value is "1".

.PARAMETER Method
The method to be used for the network scan. Default value is "enhancedScript".

.PARAMETER NextStart
The next start time for the network scan. Default value is "manual".

.PARAMETER NextStartEpoch
The next start epoch for the network scan. Default value is "0".

.PARAMETER GroovyScript
The Groovy script to be executed during the network scan.

.PARAMETER CredentialGroupId
The ID of the credential group to be used for the network scan.

.PARAMETER CredentialGroupName
The name of the credential group to be used for the network scan.

.EXAMPLE
New-LMEnhancedNetScan -CollectorId "12345" -Name "MyNetScan" -NetScanGroupName "Group1" -CustomCredentials $customCreds -Filters $filters -Description "This is a network scan" -ExcludeDuplicateType "1" -Method "enhancedScript" -NextStart "manual" -NextStartEpoch "0" -GroovyScript "script" -CredentialGroupId "67890" -CredentialGroupName "Group2"

This example creates a new enhanced network scan with the specified parameters.

.NOTES
For more information about LogicMonitor network scans, refer to the LogicMonitor documentation.
#>
Function New-LMEnhancedNetScan {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$CollectorId,

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$NetScanGroupName,

        [System.Collections.Generic.List[PSCustomObject]]$CustomCredentials,

        [System.Collections.Generic.List[PSCustomObject]]$Filters,

        [String]$Description,
        
        [String]$ExcludeDuplicateType = "1",

        [ValidateSet("enhancedScript")]
        [String]$Method = "enhancedScript",

        [String]$NextStart = "manual",

        [String]$NextStartEpoch = "0",

        [String]$GroovyScript,

        [String]$CredentialGroupId,

        [String]$CredentialGroupName
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/netscans"

            #Get Netscan GroupID
            If($NetScanGroupName){
                $NetScanGroupId = (Get-LMNetScanGroup -Name $NetScanGroupName).Id
            }
            Else{
                $NetScanGroupId = 1
            }

            #Get cred group name
            If ($CredentialGroupId -and !$CredentialGroupName) {
                $CredentialGroupName = (Get-LMDeviceGroup -Id $CredentialGroupId).Name
            }

            #Get cred group name
            If ($CredentialGroupName -and !$CredentialGroupId) {
                $CredentialGroupName = (Get-LMDeviceGroup -Name $CredentialGroupName).Id
            }

            $Duplicates = @{
                collectors = @()
                groups     = @()
                type       = $ExcludeDuplicateType
            }

            $Creds = @{
                custom          = $CustomCredentials
                deviceGroupId   = $CredentialGroupId
                deviceGroupName = $CredentialGroupName
            }

            $Schedule = @{
                cron       = ""
                notify     = $false
                recipients = @()
                timezone   = "America/New_York"
                type       = "manual"
            }

            Try {
                $Data = @{
                    name                      = $Name
                    collector                 = $CollectorId
                    description               = $Description
                    duplicate                 = $Duplicates
                    method                    = $Method
                    nextStart                 = $NextStart
                    groovyScript              = $GroovyScript
                    nextStartEpoch            = $NextStartEpoch
                    nsgId                     = $NetScanGroupId
                    credentials               = $Creds
                    filters                   = $Filters
                    schedule                  = $Schedule
                    scriptType                = "embeded"
                }

                
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
                $Data = ($Data | ConvertTo-Json -Depth 10)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScan" )
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
