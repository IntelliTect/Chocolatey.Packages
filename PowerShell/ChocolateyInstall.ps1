try 
{
  [string] $packageName="PowerShell 3.0" 
  [string] $fileType="exe" 
  [string] $silentArgs="/quiet /norestart /log:`"$env:TEMP\PowerShell.v3.log`""
  [string] $url = "http://download.microsoft.com/download/5/2/B/52B59966-3009-4F39-A99E-3732717BBE2A/Windows6.1-KB2506143-x86.msu"
  [string] $url64bit = "http://download.microsoft.com/download/5/2/B/52B59966-3009-4F39-A99E-3732717BBE2A/Windows6.1-KB2506143-x64.msu"
  [string[]] $validExitCodes = @(0, 3010)
  [string] $wusaExe="wusa.exe"


  $chocTempDir = Join-Path $env:TEMP "chocolatey"
  $tempDir = Join-Path $chocTempDir "$packageName"
  if (![System.IO.Directory]::Exists($tempDir)) 
  {
      [System.IO.Directory]::CreateDirectory($tempDir)
  }

  $file = Join-Path $tempDir "$($packageName) Install.$fileType"
  
  if(!(test-path $file))
  {
      Get-ChocolateyWebFile $packageName $file $url $url64bit
  }

  $silentArgs="`"$file`" $silentArgs"

  Install-ChocolateyInstallPackage $packageName $fileType $silentArgs $wusaExe -validExitCodes $validExitCodes

  Write-Warning "$packageName requires a reboot to complete the installation."

  Write-ChocolateySuccess $packageName
}
catch
{
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
}


