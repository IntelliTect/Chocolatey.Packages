param(
    $packageVersion = "v1.3"
)

. $PSScriptRoot\build.ps1

$packageName = "Everyting"

Create-ChocolateyPackage "$PSScriptRoot\$packageName\$packageVersion"

