param(
    $packageVersion = "v2.3"
)

. $PSScriptRoot\build.ps1

$packageName = (split-path $PSCommandPath -leaf) -replace "Build.","" -replace ".ps1",""

#Write-Host "NuspecPath =`'$PSScriptRoot\$packageName\$packageVersion\Project.nuspec`'($(Test-Path $PSScriptRoot\$packageName\$packageVersion\Project.nuspec))"

Create-ChocolateyPackage (Resolve-Path "$PSScriptRoot\$packageName\$packageVersion\Project.nuspec")

