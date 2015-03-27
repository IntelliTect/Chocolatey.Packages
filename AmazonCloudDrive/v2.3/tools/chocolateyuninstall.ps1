#NOTE: Please remove any commented lines to tidy up prior to releasing the package, including this one

# stop on all errors
$ErrorActionPreference = 'Stop';

# Auto Uninstaller should be able to detect and handle registry uninstalls (if it is turned on, it is in preview for 0.9.9).

$packageName = 'AmazonCloudDrive'
$registryUninstallerKeyName = 'Amazon Cloud Drive' #ensure this is the value in the registry
$installerType = 'EXE'
$silentArgs = '/S'
$validExitCodes = @(0)


<#Private#> Function Script:Get-ProgramRegistryKeys {
    [CmdletBinding()] param()

    return [string] "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
                  "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
                  "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall",
                  "Microsoft.PowerShell.Core\Registry::HKEY_USERS\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Uninstall"
}

Function Get-Program {
    [CmdletBinding()] param([string] $Filter = "*") 

    Get-ChildItem (Get-ProgramRegistryKeys) | Get-ItemProperty | 
            Select-Object  *,@{Name="Name"; Expression = { 
                if( ($_ | Get-Member "DisplayName") -and $_.DisplayName) { #Consider $_.PSObject.Properties.Match("DisplayName") as it may be faster
                    $_.DisplayName
                } 
                else { 
                    $_.PSChildName 
                } 
            }} | 
            ?{ ($_.Name -Like $Filter) -or ($_.PSChildName -Like $Filter)  } 
}
$amazonCloudDriveProgram = Get-Program "Amazon Cloud Drive"

$file =$amazonCloudDriveProgram.UninstallString

##$osBitness = Get-ProcessorBits
#if ($osbitness -eq 64) {
#  $file = (get-itemproperty -path "hklm:\software\wow6432node\microsoft\windows\currentversion\uninstall\$registryuninstallerkeyname").uninstallstring
#} else {
#  $file = (get-itemproperty -path "hklm:\software\microsoft\windows\currentversion\uninstall\$registryuninstallerkeyname").uninstallstring
#} 
	
Uninstall-ChocolateyPackage -PackageName $packageName -FileType $installerType -SilentArgs $silentArgs -validExitCodes $validExitCodes -File $file
