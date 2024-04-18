<#
.SYNOPSIS
Downloads the LogicMonitor Collector installer based on the specified parameters.

.DESCRIPTION
The Get-LMCollectorInstaller function downloads the LogicMonitor Collector installer based on the specified parameters. It requires a valid API authentication and can be used to download the installer for a specific collector by its ID or name. The function supports different operating systems and architectures, as well as collector sizes.

.PARAMETER Id
The ID of the collector for which to download the installer. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The name of the collector for which to download the installer. This parameter is mandatory when using the 'Name' parameter set.

.PARAMETER Size
The size of the collector. Valid values are 'nano', 'small', 'medium', 'large', 'extra_large', and 'double_extra_large'. The default value is 'medium'.

.PARAMETER OSandArch
The operating system and architecture of the collector. Valid values are 'Win64' and 'Linux64'. The default value is 'Win64'.

.PARAMETER UseEA
Specifies whether to use the Early Access (EA) version of the collector. By default, this parameter is set to $false.

.PARAMETER DownloadPath
The path where the downloaded installer file will be saved. By default, it is set to the current location.

.EXAMPLE
PS> Get-LMCollectorInstaller -Id 1234 -Size medium -OSandArch Win64 -DownloadPath "C:\Downloads"

Downloads the LogicMonitor Collector installer for the collector with ID 1234, using the 'medium' size and 'Win64' operating system and architecture. The installer file will be saved in the "C:\Downloads" directory.

.EXAMPLE
PS> Get-LMCollectorInstaller -Name "MyCollector" -Size large -OSandArch Linux64

Downloads the LogicMonitor Collector installer for the collector with the name "MyCollector", using the 'large' size and 'Linux64' operating system and architecture. The installer file will be saved in the current location.

#>
Function Get-LMCollectorInstaller {
    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = "Id")]
        [int]$Id,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [string]$Name,

        [ValidateSet("nano", "small", "medium", "large", "extra_large","double_extra_large")]
        [string]$Size = "medium",

        [ValidateSet("Win64", "Linux64")]
        [string]$OSandArch = "Win64",

        [boolean]$UseEA = $false,

        [string]$DownloadPath = (Get-Location).Path
    )
    
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        If ($Name) {
            $LookupResult = (Get-LMCollector -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }
        
        #Build header and uri
        $ResourcePath = "/setting/collector/collectors/$Id/installers/$OSandArch"
        $QueryParams = "?useEA=$UseEA&collectorSize=$Size"

        If ($OSandArch -like "Linux*") {
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch`_$Size`_$Id.bin"
        }
        Else {
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch`_$Size`_$Id.exe"
        }

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
            Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1] -OutFile $DownloadPath
            
            Return $DownloadPath

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
