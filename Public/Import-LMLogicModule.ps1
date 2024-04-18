<#
.SYNOPSIS
Imports a LogicModule into LogicMonitor.

.DESCRIPTION
The Import-LMLogicModule function imports a LogicModule into LogicMonitor. It can import the LogicModule from a file path or directly from file data. The LogicModule can be of different types such as datasource, propertyrules, eventsource, topologysource, or configsource.

.PARAMETER FilePath
Specifies the path of the file containing the LogicModule to import. This parameter is mandatory when using the 'FilePath' parameter set.

.PARAMETER File
Specifies the file data of the LogicModule to import. This parameter is mandatory when using the 'File' parameter set.

.PARAMETER Type
Specifies the type of the LogicModule to import. The valid values are 'datasource', 'propertyrules', 'eventsource', 'topologysource', or 'configsource'. The default value is 'datasource'.

.PARAMETER ForceOverwrite
Indicates whether to overwrite an existing LogicModule with the same name. If set to $true, the existing LogicModule will be overwritten. If set to $false, an error will be thrown if a LogicModule with the same name already exists. The default value is $false.

.EXAMPLE
Import-LMLogicModule -FilePath "C:\LogicModules\datasource.xml" -Type "datasource" -ForceOverwrite $true
Imports a datasource LogicModule from the file 'datasource.xml' located in the 'C:\LogicModules' directory. If a LogicModule with the same name already exists, it will be overwritten.

.EXAMPLE
Import-LMLogicModule -File $fileData -Type "propertyrules"
Imports a propertyrules LogicModule using the file data provided in the $fileData variable. If a LogicModule with the same name already exists, an error will be thrown.

.NOTES
This function requires PowerShell version 6.1 or higher to run.
#>
Function Import-LMLogicModule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'FilePath')]
        [String]$FilePath,

        [Parameter(Mandatory,ParameterSetName = 'File')]
        [Object]$File,
        
        [ValidateSet("datasource", "propertyrules", "eventsource", "topologysource", "configsource")]
        [String]$Type = "datasource",

        [Boolean]$ForceOverwrite = $false
    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($Script:LMAuth.Valid) {
            
            #Get file content from path if not given file data directly
            If($FilePath){

                #Check for PS version 6.1 +
                If (($PSVersionTable.PSVersion.Major -le 5) -or ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -lt 1)) {
                    Write-Error "This command requires PS version 6.1 or higher to run."
                    return
                }

                If (!(Test-Path -Path $FilePath) -and ((!([IO.Path]::GetExtension($FilePath) -eq '.xml')) -or (!([IO.Path]::GetExtension($FilePath) -eq '.json')))) {
                    Write-Error "File not found or is not a valid xml/json file, check file path and try again"
                    Return
                }

                $File = Get-Content $FilePath -Raw
            }
            
            #Build query params
            $QueryParams = "?type=$Type&forceOverwrite=$ForceOverwrite"

            #Build header and uri
            $ResourcePath = "/setting/logicmodules/importfile"

            Try {

                $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $File
                $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation  -Payload $FilePath

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Form @{file = $File }

                Return "Successfully imported LogicModule of type: $($Response.items.type)"

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