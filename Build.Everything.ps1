param(
    $packageVersion = "v1.3"
)

. $PSScriptRoot\build.ps1

$packageName = "Everything"

#Write-Host "NuspecPath =`'$PSScriptRoot\$packageName\$packageVersion\Project.nuspec`'($(Test-Path $PSScriptRoot\$packageName\$packageVersion\Project.nuspec))"

Create-ChocolateyPackage (Resolve-Path "$PSScriptRoot\$packageName\$packageVersion\Project.nuspec")

