<#
.SYNOPSIS
Removes a LogicMonitor role.

.DESCRIPTION
The Remove-LMRole function removes a LogicMonitor role based on the specified Id or Name. It requires a valid API authentication and authorization.

.PARAMETER Id
The Id of the role to be removed. This parameter is mandatory when using the 'Id' parameter set.

.PARAMETER Name
The Name of the role to be removed. This parameter is mandatory when using the 'Name' parameter set.

.EXAMPLE
Remove-LMRole -Id 123
Removes the LogicMonitor role with the Id 123.

.EXAMPLE
Remove-LMRole -Name "Admin"
Removes the LogicMonitor role with the Name "Admin".

.INPUTS
None. You cannot pipe objects to this function.

.OUTPUTS
System.Management.Automation.PSCustomObject. Returns an object with the Id and a success message if the role is successfully removed.

.NOTES
This function requires a valid API authentication and authorization. Use Connect-LMAccount to log in before running this command.
#>
Function Remove-LMRole {

    [CmdletBinding(DefaultParameterSetName = 'Id',SupportsShouldProcess,ConfirmImpact='High')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [Int]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name

    )
    Begin {}
    Process {
        #Check if we are logged in and have valid api creds
        If ($Script:LMAuth.Valid) {

            #Lookup Id if supplying username
            If ($Name) {
                $LookupResult = (Get-LMRole -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
            
            #Build header and uri
            $ResourcePath = "/setting/roles/$Id"

            If($PSItem){
                $Message = "Id: $Id | Name: $($PSItem.name)"
            }
            ElseIf($Name){
                $Message = "Id: $Id | Name: $Name"
            }
            Else{
                $Message = "Id: $Id"
            }

            #Loop through requests 
            Try {
                If ($PSCmdlet.ShouldProcess($Message, "Remove User Role")) {                    
                    $Headers = New-LMHeader -Auth $Script:LMAuth -Method "DELETE" -ResourcePath $ResourcePath
                    $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath
    
                    Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation

                #Issue request
                    $Response = Invoke-RestMethod -Uri $Uri -Method "DELETE" -Headers $Headers[0] -WebSession $Headers[1]
                    
                    $Result = [PSCustomObject]@{
                        Id = $Id
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
    End {}
}
