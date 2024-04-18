<#
.SYNOPSIS
Creates a new LogicMonitor collector group.

.DESCRIPTION
The New-LMCollectorGroup function creates a new collector group in LogicMonitor. It requires a name parameter and supports additional parameters such as description, properties, autoBalance, and autoBalanceInstanceCountThreshold.

.PARAMETER Name
The name of the collector group. This parameter is mandatory.

.PARAMETER Description
The description of the collector group.

.PARAMETER Properties
A hashtable of custom properties for the collector group.

.PARAMETER AutoBalance
Specifies whether to enable auto-balancing for the collector group. The default value is $false.

.PARAMETER AutoBalanceInstanceCountThreshold
The threshold for auto-balancing the collector group. The default value is 10000.

.EXAMPLE
New-LMCollectorGroup -Name "MyCollectorGroup" -Description "This is a new collector group" -Properties @{ "Property1" = "Value1"; "Property2" = "Value2" }

This example creates a new collector group named "MyCollectorGroup" with a description and custom properties.

.NOTES
For this function to work, you need to be logged in with valid API credentials. Use the Connect-LMAccount function to log in before running this command.
#>
Function New-LMCollectorGroup {

    [CmdletBinding()]
    Param (

        [Parameter(Mandatory)]
        [String]$Name,

        [String]$Description,

        [Hashtable]$Properties,

        [Nullable[boolean]]$AutoBalance = $false,

        [Nullable[Int]]$AutoBalanceInstanceCountThreshold = 10000

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
            $ResourcePath = "/setting/collector/groups"

            Try {
                $Data = @{
                    description                         = $Description
                    name                                = $Name
                    autoBalance                         = $AutoBalance
                    customProperties                    = $customProperties
                    autoBalanceInstanceCountThreshold   = $AutoBalanceInstanceCountThreshold
                }

            
                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_])) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.CollectorGroup" )
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
