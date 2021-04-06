Function Get-LMWebsiteData {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Datetime]$StartDate,

        [Datetime]$EndDate,

        [String]$CheckpointId = 0
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {
        #If using id we still need to grab a checkpoint is not specified
        If ($Id) {
            $Website = (Get-LMWebsite -Id $Id | Select-Object -First 1)
            $CheckpointId = $Website.Checkpoints[0].id
        }

        #Lookup Id and checkpoint if supplying username
        If ($Name) {
            If ($Name -Match "\*") {
                Write-Host "Wildcard values not supported for website name." -ForegroundColor Yellow
                return
            }
            $Website = (Get-LMWebsite -Name $Name | Select-Object -First 1)
            $Id = $Website.Id
            $CheckpointId = $Website.Checkpoints[0].id
            If (!$Id) {
                Write-Host "Unable to find website: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/website/websites/$Id/checkpoints/$CheckpointId/data"

        #Convert to epoch, if not set use defaults
        If (!$StartDate) {
            [int]$StartDate = ([DateTimeOffset]$(Get-Date).AddMinutes(-60)).ToUnixTimeSeconds()
        }
        Else {
            [int]$StartDate = ([DateTimeOffset]$($StartDate)).ToUnixTimeSeconds()
        }

        If (!$EndDate) {
            [int]$EndDate = ([DateTimeOffset]$(Get-Date)).ToUnixTimeSeconds()
        }
        Else {
            [int]$EndDate = ([DateTimeOffset]$($EndDate)).ToUnixTimeSeconds()
        }

        #Build query params
        $QueryParams = "?size=$BatchSize&start=$StartDate&end=$EndDate"

        Try {
            $Headers = New-LMHeader -Auth $global:LMAuth -Method "GET" -ResourcePath $ResourcePath
            $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers
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
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
