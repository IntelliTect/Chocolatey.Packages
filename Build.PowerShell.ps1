param(
    $packageVersion = "v4.0"
)

. $PSScriptRoot\build.ps1

$packageName = "PowerShell"

Create-ChocolateyPackage "$PSScriptRoot\$packageName\$packageVersion"

