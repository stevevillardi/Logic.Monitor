Function New-LMNetScan {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$CollectorId,

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,
        
        [String]$ExcludeDuplicateType = "1",

        [Nullable[boolean]]$IgnoreSystemIpDuplicates = $false,

        [ValidateSet("nmap")]
        [String]$Method = "nmap",

        [String]$NextStart = "manual",

        [String]$NextStartEpoch = "0",

        [String]$NetScanGroupId = "1",

        [Parameter(Mandatory)]
        [String]$SubnetRange,

        [String]$CredentialGroupId,

        [String]$CredentialGroupName,

        [String]$ChangeNameToken = "##REVERSEDNS##"
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build header and uri
            $ResourcePath = "/setting/netscans"

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

            $DDR = @{
                assignment = @()
                changeName = $ChangeNameToken
            }

            $Creds = @{
                custom          = @()
                deviceGroupId   = $CredentialGroupId
                deviceGroupName = $CredentialGroupName
            }

            $Ports = @{
                isGlobalDefault = $true
                value           = "21,22,23,25,53,69,80,81,110,123,135,143,389,443,445,631,993,1433,1521,3306,3389,5432,5672,6081,7199,8000,8080,8081,9100,10000,11211,27017"
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
                    ignoreSystemIPsDuplicates = $IgnoreSystemIpDuplicates
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
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
                
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Body $Data

                Return $Response
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
        Else {
            Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}
