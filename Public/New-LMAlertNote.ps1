<#
.SYNOPSIS
Creates a new note for one or more LogicMonitor alerts.

.DESCRIPTION
The New-LMAlertNote function creates a new note for one or more LogicMonitor alerts. It requires the alert IDs and the note content as mandatory parameters.

.PARAMETER Ids
Specifies the alert IDs for which the note needs to be created. This parameter accepts an array of strings.

.PARAMETER Note
Specifies the content of the note to be created. This parameter accepts a string.

.EXAMPLE
New-LMAlertNote -Ids @("12345","67890") -Note "This is a sample note."

This example creates a new note with the content "This is a sample note" for the alerts with IDs "12345" and "67890".

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.String. Returns a success message if the note is created successfully.
#>
Function New-LMAlertNote {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [String[]]$Ids,
        [Parameter(Mandatory)]
        [String]$Note
    )
    Begin{}
    Process{
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {
            
            #Build header and uri
            $ResourcePath = "/alert/alerts/note"
    
            Try {
    
                $Data = @{
                    alertIds = $Ids
                    note  = $Note
                }
    
                $Data = ($Data | ConvertTo-Json)
    
                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-WebRequest -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data
    
                If($Response.StatusCode -eq 200){
                    Return "Successfully updated note for alert id(s): $Ids"
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
