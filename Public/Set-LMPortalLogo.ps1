Function Set-LMPortalLogo {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [String]$LogoPath

    )

    #Check if we are logged in and have valid api creds
    Begin {}
    Process {
        If ($global:LMAuth.Valid) {
            $Extension = $([IO.Path]::GetExtension($LogoPath)).Replace(".","")

            #Check for PS version 6.1 +
            If (($PSVersionTable.PSVersion.Major -le 5) -or ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -lt 1)) {
                Write-Host "This command requires PS version 6.1 or higher to run."
                return
            }

            If (!(Test-Path -Path $LogoPath) -and ((!($Extension -ieq 'jpeg')) -or (!($Extension -ieq 'jpg')) -or (!($Extension -ieq 'png')) -or (!($Extension -ieq 'gif')))) {
                Write-Host "File not found or is not a valid jpeg/jpg/gif/png file, check file path and try again" -ForegroundColor Yellow
                Return
            }

            #Get file content
            $File = Get-Content $LogoPath -Raw
            
            Try {
                #Build header and uri
                $ResourcePath = "/setting/upload/loginLogo"
                
                #Set LoginLogo
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $File 
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Form @{file = $File }
                Write-Host "Successfully imported loginLogo $([IO.Path]::GetFileName($LogoPath)) of type: $($Response.items.type)"

                #Build header and uri
                $ResourcePath = "/setting/upload/companyLogo"

                #Set CompanyLogo
                $Headers = New-LMHeader -Auth $global:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $File 
                $Uri = "https://$($global:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

                #Issue request
                $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers -Form @{file = $File }
                Write-Host "Successfully imported companyLogo $([IO.Path]::GetFileName($LogoPath)) of type: $($Response.items.type)"

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
            Write-Host "Please ensure you are logged in before running any comands, use Connect-LMAccount to login and try again." -ForegroundColor Yellow
        }
    }
    End {}
}