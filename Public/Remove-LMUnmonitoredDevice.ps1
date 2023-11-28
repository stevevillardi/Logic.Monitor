Function Remove-LMUnmonitoredDevice {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [String[]]$Ids

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/device/unmonitoreddevices/batchdelete"

            $Message = "Id(s): $Ids"
    
            Try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove Unmonitored Devices")) {                    
                    [String[]]$Data = $Ids
                    $Data = ($Data | ConvertTo-Json -AsArray)
    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                    
                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.UnmonitoredDevice" )
                }
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
