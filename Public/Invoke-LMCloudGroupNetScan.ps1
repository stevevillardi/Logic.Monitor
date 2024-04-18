<#
.SYNOPSIS
Invokes a LogicMonitor Cloud Group NetScan task.

.DESCRIPTION
The Invoke-LMCloudGroupNetScan function is used to schedule a LogicMonitor Cloud Group NetScan task. It requires either the GroupId or GroupName parameter to identify the target device group.

.PARAMETER Id
Specifies the ID of the target device group. This parameter is mandatory when using the 'GroupId' parameter set.

.PARAMETER Name
Specifies the name of the target device group. This parameter is mandatory when using the 'GroupName' parameter set.

.EXAMPLE
Invoke-LMCloudGroupNetScan -Id "12345"
Schedules a LogicMonitor Cloud Group NetScan task for the device group with the ID "12345".

.EXAMPLE
Invoke-LMCloudGroupNetScan -Name "MyGroup"
Schedules a LogicMonitor Cloud Group NetScan task for the device group with the name "MyGroup".

.NOTES
This function requires a valid LogicMonitor API authentication. Make sure you are logged in before running any commands using the Connect-LMAccount cmdlet. You must target a device gropup that belongs to a cloud account (EC2, etc)
#>
Function Invoke-LMCloudGroupNetScan {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'GroupId')]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'GroupName')]
        [String]$Name
    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $GroupInfo = Get-LMDeviceGroup -Name $Name
                $LookupResult = $GroupInfo.Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    Return
                }
                $Id = $LookupResult
            }
            Else{
                $GroupInfo = Get-LMDeviceGroup -Id $Id
            }

            If($GroupInfo.groupType -notlike "*AWS*" -and $GroupInfo.groupType -notlike "*Azure*" -and $GroupInfo.groupType -notlike "*GCP*"){
                Write-Error "Specified group: $($GroupInfo.Name) is not of type AWs/Azure/GCP. Please ensure the specified group is a Cloud group and try again."
            }
                
            #Build header and uri
            $ResourcePath = "/device/groups/$Id/scheduleNetscans"

            Try {
    
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "GET" -ResourcePath $ResourcePath
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "GET" -Headers $Headers[0] -WebSession $Headers[1]

                Return "Scheduled LMCloud NetScan task for NetScan id: $Id."
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
