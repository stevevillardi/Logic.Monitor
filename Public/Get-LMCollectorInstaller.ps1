Function Get-LMCollectorInstaller
{

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (

        [Parameter(Mandatory, ParameterSetName = "Id")]
        [int]$Id,

        [Parameter(ParameterSetName = "Name")]
        [string]$Name,

        [ValidateSet("nano", "small", "medium", "large")]
        [string]$Size = "medium",

        [ValidateSet("Win32", "Win64", "Linux32", "Linux64")]
        [string]$OSandArch = "Win64",

        [boolean]$UseEA = $false,

        [string]$DownloadPath = $PSScriptRoot
    )
    
    #Check if we are logged in and have valid api creds
    If($global:LMAuth.Valid){

        If($Name){
            If($Name -Match "\*"){
                Write-Host "Wildcard values not supported for collector name." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMCollector -Name $Name | Select-Object -First 1 ).Id
            If(!$Id){
                Write-Host "Unable to find collector host with name: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/setting/collector/collectors/$Id/installers/$OSandArch"
        $QueryParams = "?useEA=$UseEA&collectorSize=$Size"

        If($OSandArch -like "Linux*"){
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch($Size).bin"
        }
        Else{
            $DownloadPath += "\LogicMonitor_Collector_$OSandArch($Size).exe"
        }

        Try{
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            Invoke-WebRequest -Uri $Uri -Method "GET" -Headers $Headers -OutFile $DownloadPath
            
            Return $DownloadPath

        }
        Catch{
            $LMError = $_.ErrorDetails | ConvertFrom-Json -ErrorAction SilentlyContinue
            Write-Error "Failed to execute query: $($LMError.errorMessage) - $($LMError.errorCode)"
        }
    }
    Else{
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
