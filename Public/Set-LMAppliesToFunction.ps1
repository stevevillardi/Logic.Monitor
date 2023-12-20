Function Set-LMAppliesToFunction {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [Parameter(Mandatory, ParameterSetName = 'Id',ValueFromPipelineByPropertyName)]
        [String]$Id,

        [String]$Description,

        [String]$AppliesTo

    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Lookup Id if supplying name
        If ($Name) {
            $LookupResult = (Get-LMAppliesToFunction -Name $Name).Id
            If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                return
            }
            $Id = $LookupResult
        }

        
        #Build header and uri
        $ResourcePath = "/setting/functions/$Id"

        If($PSItem){
            $Message = "Id: $Id | Name: $($PSItem.name)"
        }
        Else{
            $Message = "Id: $Id"
        }

        Try {
            $Data = @{
                name                                = $NewName
                description                         = $Description
                code                                = $AppliesTo
            }

            #Remove empty keys so we dont overwrite them
            @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }

            $Data = ($Data | ConvertTo-Json)

            If ($PSCmdlet.ShouldProcess($Message, "Set AppliesTo Function")) {  
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.AppliesToFunction" )
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
