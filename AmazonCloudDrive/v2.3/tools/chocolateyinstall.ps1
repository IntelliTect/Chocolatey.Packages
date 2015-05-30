#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

# stop on all errors
$ErrorActionPreference = 'Stop';


$packageName = 'AmazonCloudDrive' # arbitrary name for the package, used in messages
$registryUninstallerKeyName = 'Amazon Cloud Drive' #ensure this is the value in the registry
$installerType = 'EXE' #only one of these: exe, msi, msu

function script:Get-AmazonCloudDriveInstallUrl($url) {
    $content= $WebClient.DownloadString($url)
    return [Regex]::Matches($content, $regex, "IgnoreCase") | 
        %{ $_.Groups[1].value } | 
            ?{ $_ -like "*AmazonCloudDriveSetup.exe" }
}


$url = (Get-AmazonCloudDriveInstallUrl "https://www.amazon.com/gp/drive/app-download")
$url64 = '' # 64bit URL here or remove - if installer decides, then use $url
$silentArgs = '/S' # "/s /S /q /Q /quiet /silent /SILENT /VERYSILENT" # try any of these to get the silent installer #msi is always /quiet
$validExitCodes = @(0) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

#Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" ["$url64"  -validExitCodes $validExitCodes -checksum $checksum -checksumType $checksumType -checksum64 $checksum64 -checksumType64 $checksumType64]
Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url"
