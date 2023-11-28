# Function Set-LMPortalLogo {
#     [CmdletBinding()]
#     Param (
#         [Parameter()]
#         [String]$LogoPath

#     )

#     #Check if we are logged in and have valid api creds
#     Begin {}
#     Process {
#         If ($Script:LMAuth.Valid) {
#             $Extension = $([IO.Path]::GetExtension($LogoPath)).Replace(".","")

#             #Check for PS version 6.1 +
#             If (($PSVersionTable.PSVersion.Major -le 5) -or ($PSVersionTable.PSVersion.Major -eq 6 -and $PSVersionTable.PSVersion.Minor -lt 1)) {
#                 Write-Error "This command requires PS version 6.1 or higher to run."
#                 return
#             }

#             If (!(Test-Path -Path $LogoPath) -and ((!($Extension -ieq 'jpeg')) -or (!($Extension -ieq 'jpg')) -or (!($Extension -ieq 'png')) -or (!($Extension -ieq 'gif')))) {
#                 Write-Error "File not found or is not a valid jpeg/jpg/gif/png file, check file path and try again"
#                 Return
#             }
            
#             Try {
#                 #Get file content
#                 #$FileRaw = Get-Content -Path $LogoPath -Raw
#                 $FileRaw = ([System.IO.File]::ReadAllBytes((Resolve-Path -Path $LogoPath).Path))
                
#                 $FormData = @{
#                     file = Get-Item  -Path $LogoPath
#                     name="file"
#                 }

#                 #Build header and uri
#                 $ResourcePath = "/setting/upload/loginLogo"
                
#                 #Set LoginLogo
#                 $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $FileRaw
#                 $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

#                 Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
#                 $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Form $FormData
#                 Write-LMHost "Successfully imported loginLogo $([IO.Path]::GetFileName($LogoPath)) of type: $($Response.items.type)"

#                 #Build header and uri
#                 $ResourcePath = "/setting/upload/companyLogo"

#                 #Set CompanyLogo
#                 $Headers = New-LMHeader -Auth $Script:LMAuth -Method "POST" -ResourcePath $ResourcePath -Data $FileRaw
#                 $Uri = "https://$($Script:LMAuth.Portal).logicmonitor.com/santaba/rest" + $ResourcePath + $QueryParams

#                 Resolve-LMDebugInfo -Url $Uri -Headers $Headers[0] -Command $MyInvocation -Payload $Data

                #Issue request
#                 $Response = Invoke-RestMethod -Uri $Uri -Method "POST" -Headers $Headers[0] -WebSession $Headers[1] -Form $FormData
#                 Write-LMHost "Successfully imported companyLogo $([IO.Path]::GetFileName($LogoPath)) of type: $($Response.items.type)"

#                 Return

#             }
#             Catch [Exception] {
#                 $Proceed = Resolve-LMException -LMException $PSItem
#                 If (!$Proceed) {
#                     Return
#                 }
#             }
#         }
#         Else {
#             Write-Error "Please ensure you are logged in before running any commands, use Connect-LMAccount to login and try again."
#         }
#     }
#     End {}
# }