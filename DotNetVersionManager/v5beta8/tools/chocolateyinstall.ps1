# IMPORTANT: Before releasing this package, copy/paste the next 2 lines into PowerShell to remove all comments from this file:
#   $f='c:\path\to\thisFile.ps1'
#   gc $f | ? {$_ -notmatch "^\s*#"} | % {$_ -replace '(^.*?)\s*?[^``]#.*','$1'} | Out-File $f+".~" -en utf8; mv -fo $f+".~" $f

$ErrorActionPreference = 'Stop'; # stop on all errors


$packageName= 'DotNetVersionManager' # arbitrary name for the package, used in messages
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = 'https://download.microsoft.com/download/1/7/3/17338720-A20D-453D-894F-3B763BA74754/DotNetVersionManager-x86.msi'
$url64      = 'https://download.microsoft.com/download/1/7/3/17338720-A20D-453D-894F-3B763BA74754/DotNetVersionManager-x64.msi'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  fileType      = 'MSI'
  url           = $url
  url64bit      = $url64
  #file         = $fileLocation

  #MSI
  silentArgs    = "/qn /norestart /l*v `"$env:TEMP\chocolatey\$($packageName)\$($packageName).MsiInstall.log ALLUSERS=1`"" # ALLUSERS=1 DISABLEDESKTOPSHORTCUT=1 ADDDESKTOPICON=0 ADDSTARTMENU=0
  validExitCodes= @(0, 3010, 1641)

  softwareName  = 'Microsoft .NET Version Manager*' #part or all of the Display Name as you see it in Programs and Features. It should be enough to be unique
}

Install-ChocolateyPackage @packageArgs

if(Test-Path "~\.dns\bin") {
    Remove-Item "~\.dnx\bin" -force -Recurse -ErrorAction Ignore
}
& "$env:ProgramFiles\Microsoft DNX\Dnvm\dnvm.cmd" setup