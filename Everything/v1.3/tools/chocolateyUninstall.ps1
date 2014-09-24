Write-Debug ("Starting " + $MyInvocation.MyCommand.Definition)


# The registry path for the uninstall command is:
#   HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Everything\UninstallString
# However, this is only visible to a 32 bit PowerShell instance (without using WMI or Remote Registry) :(
# For this reason, we are using the REG.eXE /QUERY
  $RegQueryCommand={REG.EXE QUERY "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\Everything" -v "UninstallString" /reg:32}

function GetUninstallCommand()
{
  [string]$uninstallCommand=(. $RegQueryCommand)[2].Trim().Split([string[]]@("    "), [StringSplitOptions]::RemoveEmptyEntries)[2]
  if($LASTEXITCODE -ne 0) 
  {
    Write-Error "The uninstall registry setting appears to be missing (`$LASTEXITCODE=$LASTEXITCODE)"
  }
  return $uninstallCommand;
}

function Uninstall()
{
  Get-Process Everything | Stop-Process  #Not required unless the Everything window is open for a search (the default immediately after install 
  $uninstallCommand = GetUninstallCommand
  $(Start-Process $uninstallCommand /S -Wait)
  if($LASTEXITCODE -ne 0) 
  {
    Write-Error "The application uninstall command failed."
  }
}

function VerifyUninstall()
{
  #Requery the registry settings to verify they were removed during uninstall.
  . $RegQueryCommand  2> out-null
  if($LASTEXITCODE -eq 0) {Write-Error "The application was NOT successfully uninstalled as registry settings remain. (`$LASTEXITCODE=$LASTEXITCODE)" }
  #Verify the Everything directory was removed.
  if(Test-Path ${env:ProgramFiles(x86)}\Everything) {Write-Error "The application was NOT successfully uninstalled as the '${env:ProgramFiles(x86)}\Everything' still exists." }
}

Uninstall
VerifyUninstall

Write-Debug ("Finished " + $MyInvocation.MyCommand.Definition)
