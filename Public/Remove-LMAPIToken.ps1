Function Remove-LMAPIToken {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Int]$UserId,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$UserName,

        [Parameter(Mandatory, ValueFromPipelineByPropertyName, ParameterSetName = 'AccessId')]
        [String]$AccessId,

        [Parameter(Mandatory, ParameterSetName = 'Id')]
        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [Int]$APITokenId
    )

    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup UserName Id if supplying username
            If ($UserName) {
                $LookupResult = (Get-LMUser -Name $UserName).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $UserName) {
                    return
                }
                $UserId = $LookupResult
            }

            If($AccessId){
                $LookupResult = (Get-LMAPIToken -AccessId $AccessId)
                If (Test-LookupResult -Result $LookupResult -LookupString $AccessId) {
                    return
                }
                $UserId = $LookupResult.adminId
                $APITokenId = $LookupResult.id
            }
            
            #Build header and uri
            $ResourcePath = "/setting/admins/$UserId/apitokens/$APITokenId"

            If($PSItem){
                $Message = "Id: $APITokenId | AccessId: $($PSItem.accessId)| AdminName:$($PSItem.adminName)"
            }
            Else{
                $Message = "Id: $APITokenId"
            }

            Try {
                if ($PSCmdlet.ShouldProcess($Message, "Remove API Token")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    $Result = [PSCustomObject]@{
                        Id = $APITokenId
                        Message = "Successfully removed ($Message)"
                    }
                    
                    Return $Result
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
