<#
.SYNOPSIS
Creates a new LogicMonitor report group.

.DESCRIPTION
The New-LMReportGroup function creates a new report group in LogicMonitor. It requires the name of the report group as a mandatory parameter and an optional description.

.PARAMETER Name
The name of the report group. This parameter is mandatory.

.PARAMETER Description
The description of the report group. This parameter is optional.

.EXAMPLE
New-LMReportGroup -Name "MyReportGroup" -Description "This is a sample report group"

This example creates a new report group with the name "MyReportGroup" and the description "This is a sample report group".

.NOTES
This function requires a valid API credential and authentication. Make sure you are logged in before running any commands using Connect-LMAccount.

#>
Function New-LMReportGroup {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Build custom props hashtable
            $customProperties = @()
            If ($Properties) {
                Foreach ($Key in $Properties.Keys) {
                    $customProperties += @{name = $Key; value = $Properties[$Key] }
                }
            }
                    
            #Build header and uri
            $ResourcePath = "/report/groups"

            Try {
                $Data = @{
                    description                         = $Description
                    name                                = $Name
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.NetScanGroup" )
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
