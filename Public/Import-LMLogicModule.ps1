Function Import-LMLogicModule {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory,ParameterSetName = 'FilePath')]
        [String]$FilePath,

        [Parameter(Mandatory,ParameterSetName = 'File')]
        [String]$File,
        
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

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Form @{file = $File }
                Write-LMHost "Successfully imported $([IO.Path]::GetFileName($FilePath)) of type: $($Response.items.type)"

                Return

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