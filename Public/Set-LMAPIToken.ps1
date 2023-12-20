Function Set-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='None')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$AdminId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$AdminName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [String]$Note,

        [ValidateSet("active", "suspended")]
        [String]$Status

    )

    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying AdminName
            If ($AdminName) {
                $LookupResult = (Get-LMUser -Name $AdminName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $AdminName) {
                    return
                }
                $AdminId = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/setting/admins/$AdminId/apitokens/$Id"

            If($PSItem){
                $Message = "Id: $Id | AccessId: $($PSItem.accessId)| AdminName:$($PSItem.adminName)"
            }
            Else{
                $Message = "Id: $Id"
            }

            Try {
                $Data = @{
                    note   = $Note
                    status = $Status
                }
                
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
                
                If ($Status) {
                    $Data.status = $(If ($Status -eq "active") { 2 }Else { 1 })
                }
                
                $Data = ($Data | ConvertTo-Json)
                
                If ($PSCmdlet.ShouldProcess($Message, "Set API Token")) {  
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data 
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                    #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                    Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.APIToken" )
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
    End{}
}
