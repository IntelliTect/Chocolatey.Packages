

Install-ChocolateyPackage 'Everything' 'exe' '/S' -url 'http://www.voidtools.com/Everything-1.3.4.686.x86-Setup.exe' -url64bit 'http://www.voidtools.com/Everything-1.3.4.686.x64-Setup.exe'

if(Test-Path "HKLM:\SOFTWARE\Classes\Everything.FileList\shell\open\command") {
    $everythingDir = (split-path (get-itemproperty "HKLM:\SOFTWARE\Classes\Everything.FileList\shell\open\command").'(default)'.Trim('`"').Trim(" `"%1`"")) 
}
else {
    $everythingDir = "${env:ProgramFiles}\Everything\"
}

Start-Process "$everythingDir\Everything.exe" -ArgumentList "-startup"  # Removed becuase command doesn't return.

Invoke-WebRequest "http://www.voidtools.com/es.exe" -OutFile (Join-Path $everythingDir "es.exe")

#Create es.cmd file in the chocolatey bin directory which is in the path.
@"
    @echo off
    "$everythingDir\es.exe" -n 1000 %*
"@ | 
    Out-File $env:ChocolateyInstall\bin\es.cmd -Encoding ascii
