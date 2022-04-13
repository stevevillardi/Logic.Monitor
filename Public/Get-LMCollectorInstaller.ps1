Function Get-LMCollectorInstaller {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (

        [Parameter(Mandatory, ParameterSetName = "Id")]
        [int]$Id,

        [Parameter(Mandatory, ParameterSetName = "Name")]
        [string]$Name,

        [ValidateSet("nano", "small", "medium", "large")]
        [string]$Size = "medium",

        [ValidateSet("Win32", "Win64", "Linux32", "Linux64")]
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
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch($Size).bin"
        }
        Else {
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch($Size).exe"
        }

        Try {
            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers -OutFile $DownloadPath
            
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
        Write-Error "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again."
    }
}
