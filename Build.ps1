$Global:ErrorActionPreference = 'Stop'
$Global:VerbosePreference = 'SilentlyContinue'

$buildVersion = $env:BUILD_VERSION
$manifestPath = "./Logic.Monitor.psd1"
$publicFuncFolderPath = './Public'


if (!(Get-PackageProvider | Where-Object { $_.Name -eq 'NuGet' })) {
    Install-PackageProvider -Name NuGet -force | Out-Null
}
Import-PackageProvider -Name NuGet -force | Out-Null

if ((Get-PSRepository -Name PSGallery).InstallationPolicy -ne 'Trusted') {
    Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
}

if(!(Get-Module Microsoft.PowerShell.SecretManagement -ListAvailable)){
    Install-Module Microsoft.PowerShell.SecretManagement -Force -Confirm:$false
}
if(!(Get-Module Microsoft.PowerShell.SecretStore -ListAvailable)){
    Install-Module Microsoft.PowerShell.SecretStore -Force -Confirm:$false
}

$manifestContent = (Get-Content -Path $manifestPath -Raw) -replace '<ModuleVersion>', $buildVersion

if ((Test-Path -Path $publicFuncFolderPath) -and ($publicFunctionNames = Get-ChildItem -Path $publicFuncFolderPath -Filter '*.ps1' | Select-Object -ExpandProperty BaseName)) {
    $funcStrings = "'$($publicFunctionNames -join "','")'"
} else {
    $funcStrings = $null
}

$manifestContent = $manifestContent -replace "'<FunctionsToExport>'", $funcStrings
$manifestContent | Set-Content -Path $manifestPath
