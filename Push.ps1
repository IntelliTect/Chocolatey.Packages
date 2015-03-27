[CmdletBinding()]param(
    [Parameter(Mandatory)][string]$nugetPackage
)

if(!(Test-Path $nugetPackage)) {
    $nugetPackage = Resolve-Path "$PSScriptRoot\bin\$nugetPackage"
}

if(!(Choco ApiKey)) {
    if(Test-Path C:\data\Profile\ChocolateyAPIKey.txt) {
        $apiKey = (Get-Content C:\data\Profile\ChocolateyAPIKey.txt).Trim()
    }
    elseif(Test-Path  $env:USERPROFILE\ChocolateyAPIKey.txt) {
        $apiKey = (Get-Content $env:USERPROFILE\ChocolateyAPIKey.txt).Trim()
    }
    choco SetApiKey -s"https://chocolatey.org/" -k"$apiKey"
}

Choco Push $nugetPackage

