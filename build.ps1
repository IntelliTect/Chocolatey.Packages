<#
param(
  [Parameter(Position=0,Mandatory=0)]
  [string]$buildFile, #"$(Split-Path -parent $MyInvocation.MyCommand.Definition)\build\build.ps1",
  [Parameter(Position=1,Mandatory=0)]
  [string[]]$taskList = @(),
  [Parameter(Position=2,Mandatory=0)]
  [string]$framework = '4.0x86',
  [Parameter(Position=3,Mandatory=0)]
  [switch]$docs = $false,
  [Parameter(Position=4,Mandatory=0)]
  [System.Collections.Hashtable]$parameters = @{},
  [Parameter(Position=5, Mandatory=0)]
  [System.Collections.Hashtable]$properties = @{}
)


Write-Debug ("Starting " + $MyInvocation.MyCommand.Definition)
$here = (Split-Path -parent $MyInvocation.MyCommand.Definition)
$buildPath = (Resolve-Path $here\build)

Write-Debug ("`$parameters.package = " + $parameters.package)

#. $buildPath\bootstrap.ps1 $buildPath
$psakeDirectory = @(Get-ChildItem $here\* -recurse -include psake.ps1)[0].DirectoryName
. $psakeDirectory\psake.ps1 $here\build\default.ps1 $taskList $framework $docs $parameters $properties -ScriptPath $psakeDirectory

Write-Debug ("Finished " + $MyInvocation.MyCommand.Definition)
if($env:BUILD_NUMBER) {
  [Environment]::Exit($lastexitcode)
} else {
  exit $lastexitcode
}
#>

Function Create-ChocolateyPackage {
    [CmdletBinding()] param(
        [ValidateScript({Test-Path $_ -PathType Leaf})][Parameter(Mandatory)][string]$nuspecFilePath
    )

    Choco Pack $nuspecFilePath | %{ ` # -OutputDirectory doesn't appear to work, file is instead output to current directory. 
        if($_ -match "Successfully created package '(?'NugetFile'.*)'") {
            Write-Output $Matches.NugetFile
        }
    } | %{
        Get-ChildItem (Split-Path $nuspecFilePath) $_ -Recurse
    } | %{
        Move-Item $_.FullName "$PSScriptRoot\bin\"  -Force  # Overwrite the file if it already exists
        Get-Item (Join-Path "$PSScriptRoot\bin\"  (Split-Path $_ -Leaf))  #Write the resulting nuget file to the output stream.
    }
}