param(
    $taskList,
    $parameters
)
if($parameters -eq $null) { $parameters = @{'packageDirectoryName' = 'PowerShell'} }

. "$(split-path $myInvocation.MyCommand.Definition)\build.ps1" -taskList $taskList -parameters $parameters
