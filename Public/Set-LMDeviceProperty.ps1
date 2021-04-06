Function Set-LMDeviceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [Parameter(Mandatory)]
        [String]$PropertyName,

        [Parameter(Mandatory)]
        [String]$PropertyValue
    )
    #Check if we are logged in and have valid api creds
    If ($global:LMAuth.Valid) {

        If ($Name) {
            If ($Name -Match "\*") {
                Write-Host "Wildcard values not supported for device name." -ForegroundColor Yellow
                return
            }
            $Id = (Get-LMDevice -Name $Name | Select-Object -First 1 ).Id
            If (!$Id) {
                Write-Host "Unable to find device with name: $Name, please check spelling and try again." -ForegroundColor Yellow
                return
            }
        }
        
        #Build header and uri
        $ResourcePath = "/device/devices/$Id/properties/$PropertyName"

        #Loop through requests 
        $Done = $false
        While (!$Done) {
            Try {
                $Data = @{
                    value = $PropertyValue
                }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $global:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers -Body $Data

                Return $Response
            }
            Catch [Exception] {
                $Proceed = Resolve-LMException -LMException $PSItem
                If (!$Proceed) {
                    Return
                }
            }
        }
    }
    Else {
        Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
    }
}
