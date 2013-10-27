Set-StrictMode -version 3

$here=(split-path $myInvocation.MyCommand.Definition)
$utilProfile=$myInvocation.MyCommand.Definition

Dir $here Pester.psm1 -Recurse | %{ Install-Module -ModulePath $_.FullName }
Dir $here PSake.psm1 -Recurse | %{ Install-Module -ModulePath $_.FullName }