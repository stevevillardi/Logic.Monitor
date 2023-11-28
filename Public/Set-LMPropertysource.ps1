Function Set-LMPropertysource {

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'Id', ValueFromPipelineByPropertyName)]
        [String]$Id,

        [Parameter(Mandatory, ParameterSetName = 'Name')]
        [String]$Name,

        [String]$NewName,

        [String]$Description,

        [String]$appliesTo,

        [String]$TechNotes,

        [String]$Group,

        [ValidateSet("embed", "powerShell")]
        [String]$ScriptType,

        [String]$Script

    )
    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {

            #Lookup ParentGroupName
            If ($Name) {
                $LookupResult = (Get-LMDatasource -Name $Name).Id
                If (Test-LookupResult -Result $LookupResult -LookupString $Name) {
                    return
                }
                $Id = $LookupResult
            }
                    
            #Build header and uri
            $ResourcePath = "/setting/propertyrules/$Id"

            Try {
                $Data = @{
                    name                      = $NewName
                    description               = $Description
                    appliesTo                 = $appliesTo
                    technology                = $TechNotes
                    group                     = $Group
                    groovyScript              = $Script
                    scriptType                = $ScriptType
                }

                #Remove empty keys so we dont overwrite them
                @($Data.keys) | ForEach-Object { if ([string]::IsNullOrEmpty($Data[$_]) -and ($_ -notin @($MyInvocation.BoundParameters.Keys))) { $Data.Remove($_) } }
            
                $Data = ($Data | ConvertTo-Json)

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "PATCH" -ResourcePath $ResourcePath -Data $Data
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + "?forceUniqueIdentifier=true"

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "PATCH" -Headers $Headers[0] -WebSession $Headers[1] -Body $Data

                Return (Add-ObjectTypeInfo -InputObject $Response -TypeName "LogicMonitor.Propertysource" )
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
