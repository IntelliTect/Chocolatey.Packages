[CmdletBinding(
    SupportsShouldProcess=$true,
    ConfirmImpact="Low",
    DefaultParameterSetName="Package")]
param (
        [ValidateScript({Test-Path $_ -PathType Leaf})][Parameter(Mandatory,ParameterSetName="nupkg")][Alias("PackageName")][string]$nupkgFilePath,
        [ValidateScript({$_ -in (Get-ChildItem $PSScriptRoot -Exclude bin,build,.git -Directory)})][Parameter(Mandatory,ParameterSetName="Package")][string]$Package,
        [Parameter(ParameterSetName="Package")][string]$Version,
        [string]$expectedInstallFilePath
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

function Install([string[]]$package) {
    choco install $package -source $here\bin -force
}
function Uninstall([string[]]$package) {
    choco uninstall $package
}

if(($package -eq $null) -or ($package -eq "HighTailExpress")) {
Describe "HighTailExpress" {
        function IsHighTailExpressInstalled() {
            return (Test-Path (join-path "${Env:ProgramFiles(x86)}" "Hightail\Express\Hightail.exe"));
        }
        It "Install" {
            if(IsHighTailExpressInstalled) { 
                Uninstall HighTailExpress;
                IsHighTailExpressInstalled | Should Be $false
                Install HighTailExpress
                IsHighTailExpressInstalled | Should Be $true
            } 
            else {
                Install HighTailExpress
                IsHighTailExpressInstalled | Should Be $true
                Uninstall HighTailExpress;
                IsHighTailExpressInstalled | Should Be $false
            }

        }
    }
}
else {
# Started but never tested and it isn't complete.  
Function Test-ChocolateyPackage {
    [CmdletBinding(DefaultParameterSetName="Package")]
    param(
        [ValidateScript({Test-Path $_ -PathType Leaf})][Parameter(Mandatory,ParameterSetName="nupkg")][Alias("PackageName")][string]$nupkgFilePath,
        [ValidateScript({$_ -in (Get-ChildItem $PSScriptRoot -Exclude bin,build,.git -Directory)})][Parameter(Mandatory,ParameterSetName="Package")][string]$Package,
        [Parameter(ParameterSetName="Package")][string]$Version,
        [string]$expectedInstallFilePath
    )

    if($PSCmdlet.ParameterSetName -eq "Package") {
        $packagePath = (Join-Path $PSScriptRoot "bin")
        $nupkgFilePaths = @(Get-ChildItem $packagePath "$Package." | ?{
            if($Version) {
                $_ -like "*.$version.nupkg"
            }
            else {
                $true
            }
        })
        if($nupkgFilePaths.Count -ne 1) {
            throw "No package found in '$packagePath' with name '$Package.$Version.nupkg'.".Replace("..",".")
        }
        $nupkgFilePath = $nupkgFilePaths[-1]
    }

    try {
        Install $nupkgFilePath
    }
    finally {
        Uninstall $nupkgFilePath
    }

}

Test-ChocolateyPackage @PSBoundParameters

}