if(!(Test-Path $Env:Temp\chocolatey\VisualStudioUltimate2012)) {
	New-Item $Env:Temp\chocolatey\VisualStudioUltimate2012 -ItemType Directory
}
install-chocolateypackage 'VisualStudioUltimate2012' 'exe' '/Quiet /Full /Log %Temp%\chocolatey\VisualStudioUltimate2012\VisualStudioUltimate2012.log' 'http://go.microsoft.com/?linkid=9810263'
