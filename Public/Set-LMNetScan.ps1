Function Set-LMNetscan {

    [CmdletBinding()]
    Param (

        [String]$CollectorId,

        [String]$Name,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [String]$Id,

        [String]$Description,
        
        [String]$ExcludeDuplicateType,

        [Nullable[boolean]]$IgnoreSystemIpDuplpicates,

        [String]$Method,

        [String]$NextStart,

        [String]$NextStartEpoch,

        [String]$NetScanGroupId,

        [String]$SubnetRange,

        [String]$CredentialGroupId,

        [String]$CredentialGroupName,

        [String]$ChangeNameToken,

        [String]$PortList
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/netscans/$Id"

            #Get cred group name
            If ($CredentialGroupId -and !$CredentialGroupName) {
                $CredentialGroupName = (Get-LMDeviceGroup -Id $CredentialGroupId).Name
            }

            #Get cred group name
            If ($CredentialGroupName -and !$CredentialGroupId) {
                $CredentialGroupName = (Get-LMDeviceGroup -Name $CredentialGroupName).Id
            }

            $Duplicates = $null
            If ($ExcludeDuplicateType) {
                $Duplicates = @{
                    collectors = @()
                    groups     = @()
                    type       = $ExcludeDuplicateType
                }
            }

            $DDR = $null
            If ($ChangeNameToken) {
                $DDR = @{
                    assignment = @()
                    changeName = $ChangeNameToken
                }
            }

            $Creds = $null
            If ($CredentialGroupId -or $CredentialGroupName) {
                $Creds = @{
                    custom          = @()
                    deviceGroupId   = $CredentialGroupId
                    deviceGroupName = $CredentialGroupName
                }
            }

            $Ports = $null
            If ($PortList) {
                $Ports = @{
                    isGlobalDefault = $true
                    value           = $PortList
                }
            }

            $Schedule = $null

            Try {
                $Data = @{
                    id                        = $Id
                    name                      = $Name
                    collector                 = $CollectorId
                    description               = $Description
                    duplicate                 = $Duplicates
                    ignoreSystemIPsDuplicates = $IgnoreSystemIpDuplpicates
                    method                    = $Method
                    nextStart                 = $NextStart
                    nextStartEpoch            = $NextStartEpoch
                    nsgId                     = $NetScanGroupId
                    subnet                    = $SubnetRange
                    ddr                       = $DDR
                    credentials               = $Creds
                    ports                     = $Ports
                    schedule                  = $Schedule
                }

                
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
                
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScan" )
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
