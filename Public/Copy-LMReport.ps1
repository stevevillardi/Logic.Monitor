Function Copy-LMReport {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [String]$ParentGroupId,

        [Parameter(Mandatory)]
        $ReportObject
    )
    #Check if we are logged in and have valid api creds
    If ($Script:LMAuth.Valid) {

        #Replace name and description if present
        $ReportObject.name = $Name
        If($Description){$ReportObject.description = $Description}
        If($ParentGroupId){$ReportObject.groupId = $ParentGroupId}
        
        #Build header and uri
        $ResourcePath = "/report/reports"

        Try {
            $Data = ($ReportObject | ConvertTo-Json)

            $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data 
            $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

            Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

            #Issue request
            $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

            Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Report" )
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
