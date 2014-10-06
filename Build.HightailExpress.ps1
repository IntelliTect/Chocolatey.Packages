param(
    $packageVersion = "v2.14"
)

. $PSScriptRoot\build.ps1

$packageName = "HightailExpress"

Create-ChocolateyPackage "$PSScriptRoot\$packageName\$packageVersion"

