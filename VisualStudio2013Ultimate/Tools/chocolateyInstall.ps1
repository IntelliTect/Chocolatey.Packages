if(!(Test-Path $Env:Temp\chocolatey\VisualStudio2013Ultimate)) {
	New-Item $Env:Temp\chocolatey\VisualStudio2013Ultimate -ItemType Directory
}
install-chocolateypackage 'VisualStudio2013Ultimate' 'exe' "/Passive /Full /Log $env:Temp\chocolatey\VisualStudio2013Ultimate\VisualStudio2013Ultimate.log" 'http://download.microsoft.com/download/C/F/B/CFBB5FF1-0B27-42E0-8141-E4D6DA0B8B13/vs_ultimate.exe'
