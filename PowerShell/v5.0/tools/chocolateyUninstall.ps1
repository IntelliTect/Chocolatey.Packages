Write-Debug ("Starting " + $MyInvocation.MyCommand.Definition)

[string]$packageName="PowerShell.5.0"

<#
Exit Codes:
    3010: WSUSA executed the uninstall successfully.
    2359303: The update was not found.
#>

#5.0.10105
Start-ChocolateyProcessAsAdmin "/uninstall /KB:3055381 /quiet /norestart /log:`"$env:TEMP\PowerShell.Uninstall3PowerShell5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303) 
Start-ChocolateyProcessAsAdmin "/uninstall /KB:3055377 /quiet /norestart /log:`"$env:TEMP\PowerShell.Uninstall3PowerShell5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303) 
Start-ChocolateyProcessAsAdmin "/uninstall /KB:2908075 /quiet /norestart /log:`"$env:TEMP\PowerShell.Uninstall3PowerShell5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303) 

#5.0.10514.6
Start-ChocolateyProcessAsAdmin "/uninstall /KB:3066437 /quiet /norestart /log:`"$env:TEMP\PowerShell.Uninstall3PowerShell5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303) 
Start-ChocolateyProcessAsAdmin "/uninstall /KB:3066438 /quiet /norestart /log:`"$env:TEMP\PowerShell.Uninstall3PowerShell5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303) 
Start-ChocolateyProcessAsAdmin "/uninstall /KB:3066439 /quiet /norestart /log:`"$env:TEMP\PowerShell.Uninstall3PowerShell5.evtx`"" -exeToRun "WUSA.exe" -validExitCodes @(3010,2359303) 
Write-Warning "$packageName may require a reboot to complete the uninstallation."