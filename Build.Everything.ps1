param(
    $taskList,
    $parameters
)
if($parameters -eq $null) { $parameters = @{'packageDirectoryName' = 'Everything'} }

. "$(split-path $myInvocation.MyCommand.Definition)\build.ps1" -taskList $taskList -parameters $parameters
