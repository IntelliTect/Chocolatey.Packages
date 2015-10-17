[CmdletBinding(
    SupportsShouldProcess=$true,
    ConfirmImpact="Low")]
param (
    [string[]]$package
)

$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path).Replace(".Tests.", ".")

function Install([string[]]$package) {
    cinst $package -source $here\bin
}
function Uninstall([string[]]$package) {
    cuninst $package
}

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


# Started but never tested and it isn't complete.  
Function Test-ChocolateyPackage {
    [CmdletBinding(DefaultParameterSetName="Package")]
    param(
        [ValidateScript({Test-Path $_ -PathType Leaf})][Parameter(Mandatory,ParameterSetName="nupkg")][Alias("PackageName")][string]$nupkgFilePath,
        [ValidateScript({$_ -in (Get-ChildItem $PSScriptRoot -Exclude bin,build,.git -Directory)})][Parameter(Mandatory,ParameterSetName="Package")][string]$Package,
        [Parameter(ParameterSetName="Package")][string]$Version
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
}