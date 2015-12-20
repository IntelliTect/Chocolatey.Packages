<#
See http://technet.microsoft.com/en-us/library/hh847769.aspx and http://technet.microsoft.com/en-us/library/hh847837.aspx
Windows PowerShell 5.0 runs on the following versions of Windows.
	Windows 10, installed by default
	Windows Server 2012 R2, install Windows Management Framework 5.0 to run Windows PowerShell 5.0
	Windows 8.1, install Windows Management Framework 5.0 to run Windows PowerShell 5.0
	Windows� 7 with Service Pack 1, install Windows Management Framework 4.0 and THEN WMF 5.0 (as of 5.0.10105)
	Windows Server� 2008 R2 with Service Pack 1, install Windows Management Framework 5.0 (as of 5.0.10105)
	Previous Windows versions - 5.0 is not supported.
 
Windows PowerShell 4.0 runs on the following versions of Windows.
	Windows 8.1, installed by default
	Windows Server 2012 R2, installed by default
	Windows� 7 with Service Pack 1, install Windows Management Framework 4.0 (http://go.microsoft.com/fwlink/?LinkId=293881) to run Windows PowerShell 4.0
	Windows Server� 2008 R2 with Service Pack 1, install Windows Management Framework 4.0 (http://go.microsoft.com/fwlink/?LinkId=293881) to run Windows PowerShell 4.0
 
Windows PowerShell 3.0 runs on the following versions of Windows.
	Windows 8, installed by default
	Windows Server 2012, installed by default
	Windows� 7 with Service Pack 1, install Windows Management Framework 3.0 to run Windows PowerShell 3.0
	Windows Server� 2008 R2 with Service Pack 1, install Windows Management Framework 3.0 to run Windows PowerShell 3.0
	Windows Server 2008 with Service Pack 2, install Windows Management Framework 3.0 to run Windows PowerShell 3.0
#>

try
{
    [string]$packageName="PowerShell.5.0"
    [string]$installerType="msu"
    [string]$ThisPackagePSHVersion = '5.0.10586'
    [string]$silentArgs="/quiet /norestart /log:`"$env:TEMP\PowerShell.Install.evtx`""
																										
    [string]$urlWin81x32   =                 'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win8.1-KB3094174-x86.msu'
    [string]$urlWin2k12R2andWin81x64 =       'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12R2-KB3094174-x64.msu'
    [string]$urlWin7x32   =                  'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/Win7-KB3094176-x86.msu'
    [string]$urlWin2k8R2andWin7x64 =         'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K8R2-KB3094176-x64.msu'
    [string]$urlWin2012 =                    'https://download.microsoft.com/download/2/C/6/2C6E1B4A-EBE5-48A6-B225-2D2058A9CEFB/W2K12-KB3094175-x64.msu'
  
    [string[]] $validExitCodes = @(0, 3010) # 2359302 occurs if the package is already installed.
 
    if ($PSVersionTable -and ($PSVersionTable.PSVersion -ge [Version]$ThisPackagePSHVersion)) {
	    Write-Warning "Installed PowerShell $($PSVersionTable.PSVersion) is already the same or newer than this package installs."
	}
    elseif ($PSVersionTable -and ($PSVersionTable.PSVersion -ge [Version]'5.0') -and ($PSVersionTable.PSVersion -lt [Version]$ThisPackagePSHVersion)) {
        Write-Warning "The existing PowerShell version $($PSVersionTable.PSVersion) must be uninstalled, before you can install version $ThisPackagePSHVersion."
    } 
    else {
	    # Get-CimInstance was completely crashing on win7 psh 2 even with try / catch
	    $osVersion = (Get-WmiObject Win32_OperatingSystem).Version
		$os = (Get-WmiObject "Win32_OperatingSystem")
	    $Net4Version = (get-itemproperty "hklm:software\microsoft\net framework setup\ndp\v4\full" -ea silentlycontinue | Select -Expand Release -ea silentlycontinue) 
	   
		switch ([version]$osVersion) {
            {($_ -ge [version]"6.0") -AND ($_ -le [version]"6.0.6001")} {
                Write-Verbose "OS is Vista or 2008"
                Write-Warning "The highest version for Vista/2008 is PowerShell 3.0, attempting to install..."
                cinst -y PowerShell -version 3.0.20121027
            }
            {($_ -eq [version]"6.1.7600")} {
                Write-Verbose "OS is Win7 or Server 2008 R2 (NON-SP1)"
                Write-Warning "Update to SP1 to install PowerShell V5"
                Write-Verbose "The highest version for Win7/2008R2 without SP1 is PowerShell 3.0"
                Write-Warning "Installing PowerShell 3.0"
                cinst -y PowerShell -version 3.0.20121027
            }
            {($_ -ge [version]"6.1.7601") -AND ($_ -lt [version]"6.2")} {
                Write-Verbose "OS is Win7 (SP1 or later) or Server 2008 R2 (SP1 or later), Powershell 5 may be able to be installed."
                Write-Verbose "Checking .NET version..."
                if ($Net4Version -ge 378675) {
                    # if ($false -and ($PSVersionTable.PSVersion -lt [Version]'4.0')) { Write-Warning "To put Version 5 on Windows 7 or Server 2008 R2, you must first installed Version 4 (temporary to be fixed for production release)"; Write-Warning "Will now attempt to install version 4 - after which you will need to reboot and re-run this package with -Force to have 5 installed."; cinst -y PowerShell -version 4.0.20141001; Write-Warning "PowerShell 4 requires a reboot to complete the installation."; } else {
                    Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$urlWin7x32" "$urlWin2k8R2andWin7x64"  -validExitCodes $validExitCodes
                    Write-Warning "$packageName requires a reboot to complete the installation."
                    #}
                }
                else {
                    Write-Warning ".NET Framework 4.5.1 or later required install PowerShell 4 or higher.  Use `"Choco Install dotnet4.5.1`", skipping PowerShell Install..."
                }
            }
            {($_ -ge [version]"6.2.9200") -AND ($_ -lt [version]"6.3")} {	 
                if($os.ProductType -eq 3) {
                    Write-Verbose "OS is Server 2012, PowerShell 5 may be able to be installed."
                    Write-Verbose "Checking .NET version..."
                    if ($Net4Version -ge 378675) {
                        Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$urlWin2012"  -validExitCodes $validExitCodes
                        Write-Warning "$packageName requires a reboot to complete the installation."
                    }
                    else {
                        Write-Warning ".NET Framework 4.5.1 or higher required to install PowerShell 4 or higher.  Use `"Choco Install dotnet4.5.1`""
                    }
                }
                else {
                    Write-Verbose "OS is Win 8 (not 8.1)"
                    Write-Warning "$packageName not supported on Windows 8. You must upgrade to Windows 8.1 to get WMF 4.0."
                }
            }
            {($_ -ge [version]"6.3.9600") -AND ($_ -lt [version]"6.4")} {
                Write-Verbose "OS is Win8.1 Server 2012 R2, Powershell 5 may be able to be installed."
                Write-Verbose "Checking .NET version..."
                if ($Net4Version -ge 378675) {
                    Install-ChocolateyPackage "$packageName" "$installerType" "$silentArgs" "$urlWin81x32" "$urlWin2k12R2andWin81x64"  -validExitCodes $validExitCodes
                    Write-Warning "$packageName requires a reboot to complete the installation."
                }
                else {
                    Write-Warning ".NET Framework 4.5.1 or higher required to install PowerShell 4 or higher.  Use `"Choco Install dotnet4.5.1`""
                }
            }
            {($_ -ge [version]"6.4") -or ($_ -ge [version]"10.0")} {
                Write-Verbose "OS is Windows 10"
                Write-Warning "Windows 10 has WMF / PowerShell version 5 pre-installed and cannot be upgraded."
            }
            default { 
                # Windows XP, Windows 2003, Windows Vista, or unknown?
                throw "$packageName is not supported on this operating system (Windows XP, Windows 2003, Windows Vista, or ?)."
            }
	    }
    }
}
catch {
  Throw $_.Exception
}