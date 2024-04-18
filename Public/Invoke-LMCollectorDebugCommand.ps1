<#
.SYNOPSIS
Invokes a debug command on a LogicMonitor collector.

.DESCRIPTION
The Invoke-LMCollectorDebugCommand function is used to send a debug command to a LogicMonitor collector. It supports different parameter sets based on the type of command and the identification method used (ID or name). The function checks if the user is logged in and has valid API credentials before executing the command.

.PARAMETER Id
Specifies the ID of the collector. This parameter is mandatory for the 'Id-Debug', 'Id-Posh', and 'Id-Groovy' parameter sets.

.PARAMETER Name
Specifies the name of the collector. This parameter is mandatory for the 'Name-Debug', 'Name-Posh', and 'Name-Groovy' parameter sets.

.PARAMETER DebugCommand
Specifies the debug command to be executed. This parameter is mandatory for the 'Id-Debug' and 'Name-Debug' parameter sets.

.PARAMETER PoshCommand
Specifies the PowerShell command to be executed. This parameter is mandatory for the 'Id-Posh' and 'Name-Posh' parameter sets.

.PARAMETER GroovyCommand
Specifies the Groovy command to be executed. This parameter is mandatory for the 'Id-Groovy' and 'Name-Groovy' parameter sets.

.PARAMETER CommandHostName
Specifies the host name for the command. This parameter is optional.

.PARAMETER CommandWildValue
Specifies the wild value for the command. This parameter is optional.

.PARAMETER IncludeResult
Indicates whether to include the result of the debug command. This parameter is a switch parameter.

.EXAMPLE
Invoke-LMCollectorDebugCommand -Id 1234 -DebugCommand "!account" -IncludeResult
Invokes a debug command on the collector with ID 1234 and includes the result.

.EXAMPLE
Invoke-LMCollectorDebugCommand -Name "CollectorName" -PoshCommand "Write-Host 'Hello, World!'" -IncludeResult
Invokes a PowerShell command on the collector with the name "CollectorName" and includes the result.

.EXAMPLE
Invoke-LMCollectorDebugCommand -Id 5678 -GroovyCommand "println 'Hello, World!'" -CommandHostName "Host123"
Invokes a Groovy command on the collector with ID 5678 and specifies the host name as "Host123".

.NOTES
LogicMonitor API credentials must be set before running this command. Use the Connect-LMAccount cmdlet to log in and set the credentials.
#>
Function Invoke-LMCollectorDebugCommand {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id-Debug')]
        [Parameter(Mandatory, ParameterSetName = 'Id-Posh')]
        [Parameter(Mandatory, ParameterSetName = 'Id-Groovy')]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name-Debug')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Posh')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Groovy')]
        [String]$Name,

        [Parameter(Mandatory, ParameterSetName = 'Id-Debug')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Debug')]
        [String]$DebugCommand,

        [Parameter(Mandatory, ParameterSetName = 'Id-Posh')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Posh')]
        [String]$PoshCommand,

        [Parameter(Mandatory, ParameterSetName = 'Id-Groovy')]
        [Parameter(Mandatory, ParameterSetName = 'Name-Groovy')]
        [String]$GroovyCommand,

        [String]$CommandHostName,

        [String]$CommandWildValue,

        [Switch]$IncludeResult
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

#Cannot indent or it breaks here-string format
$DefaultGroovy =@"
!groovy 
import com.santaba.agent.collector3.CollectorDb;
def hostProps = [:];
def instanceProps = [:];
try {
    hostProps = CollectorDb.getInstance().getHost("$CommandHostName").getProperties();
    instanceProps["wildvalue"] = "$CommandWildValue";
    }
catch(Exception e) {

};

$GroovyCommand
"@

#Cannot indent or it breaks here-string format
$DefaultPosh =@"
!posh 

$PoshCommand
"@

            #Lookup device name
            If ($Name) {
                $LookupResult = (Get-LMCollector -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/debug"

            #Build query params
            $QueryParams = "?collectorId=$Id"

            #Construct Body
            Switch -Wildcard ($PSCmdlet.ParameterSetName) {
                "*Debug" { $Data = @{ cmdline = $DebugCommand } }
                "*Posh" { $Data = @{ cmdline = $DefaultPosh } }
                "*Groovy" { $Data = @{ cmdline = $DefaultGroovy } }
            }

            $Data = ($Data | ConvertTo-Json)

            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                If ($IncludeResult) {
                    $CommandCompleted = $false
                    While (!$CommandCompleted) {
                        $CommandResult = Get-LMCollectorDebugResult -SessionId $Response.sessionId -Id $Id
                        If ($CommandResult.errorMessage -eq "Agent has fetched the task, waiting for response") {
                            Write-LMHost "[INFO]: Agent has fetched the task, waiting for response..." -ForegroundColor green
                            Start-Sleep -Seconds 5
                        }
                        Else {
                            $CommandCompleted = $false
                            Return $CommandResult
                        }
                    }
                }
                Else {
                    $Result = [PSCustomObject]@{
                        SessionId   = $Response.sessionId
                        CollectorId = $Id
                        Message     = "Submitted debug command task under session id $($Response.sessionId) for collector id: $($Id). Use Get-LMCollectorDebugResult to retrieve response or resubmit request with -IncludeResult"
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
            Return
        }
        Else {
            Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
        }
    }
    End {}
}