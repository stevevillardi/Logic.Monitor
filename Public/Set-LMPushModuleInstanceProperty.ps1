Function Set-LMPushModuleInstanceProperty {

    [CmdletBinding(DefaultParameterSetName = 'Id')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$DeviceId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$DeviceName,

        [Parameter(Mandatory)]
        [String]$DataSourceName,

        [Parameter(Mandatory)]
        [String]$InstanceName,

        [Parameter(Mandatory)]
        [String]$PropertyName,

        [Parameter(Mandatory)]
        [String]$PropertyValue
    )

    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            If ($DeviceName) {
                $LookupResult = (Get-LMDevice -Name $DeviceName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $DeviceName) {
                    return
                }
                $DeviceId = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/instance_property/ingest"

            Try {
                $Data = @{
                    resourceIds = @{"system.deviceid"=$DeviceId}
                    instanceName = $InstanceName
                    dataSource = $DataSourceName
                    instanceProperties = @{$PropertyName=$PropertyValue}
                }

                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

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
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End{}
}
