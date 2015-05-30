#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

# stop on all errors
$ErrorActionPreference = 'Stop';


$packageName = 'GooglePhotos' # arbitrary name for the package, used in messages
$registryUninstallerKeyName = 'GooglePhotos' #ensure this is the value in the registry
$installerType = 'EXE' #only one of these: exe, msi, msu
$url = 'https://dl.google.com/dl/picasa/gpautobackup_setup.exe'
#$url64 = '' # 64bit URL here or remove - if installer decides, then use $url
$silentArgs = '/S' 
$validExitCodes = @(0,2) #please insert other valid exit codes here, exit codes for ms http://msdn.microsoft.com/en-us/library/aa368542(VS.85).aspx
$toolsDir = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"

Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$url" -validExitCodes $validExitCodes 

Get-Process "Google Photos Backup" -ErrorAction Ignore | Stop-Process #Shut down the application which is prompting to agree. Reprompt occurs when re-launched.
