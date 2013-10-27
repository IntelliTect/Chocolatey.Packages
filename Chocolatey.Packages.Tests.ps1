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
