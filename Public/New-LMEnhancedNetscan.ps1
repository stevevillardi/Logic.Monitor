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
