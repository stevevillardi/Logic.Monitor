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

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
                If ($IncludeResult) {
                    $CommandCompleted = $false
                    While (!$CommandCompleted) {
                        $CommandResult = Get-LMCollectorDebugResult -SessionId $Response.sessionId -Id $Id
                        If ($CommandResult.errorMessage -eq "Agent has fetched the task, waiting for response") {
                            Write-LMHost "Agent has fetched the task, waiting for response..." -ForegroundColor green
                            Start-Sleep -Seconds 5
                        }
                        Else {
                            $CommandCompleted = $false
                            Return $CommandResult
                        }
                    }
                }
                Else {
                    Write-LMHost "Submitted debug command task under session id $($Response.sessionId) for device id: $($Response.sessionId). Use Get-LMCollectorDebugResult to retrieve response or resubmit request with -IncludeResult" -ForegroundColor green
                    Return $Response.sessionId
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