param(
    $taskList,
    $parameters
)
if($parameters -eq $null) { $parameters = @{'packageDirectoryName' = 'VS2012.Ultimate'} }

. "$(split-path $myInvocation.MyCommand.Definition)\build.ps1" -taskList $taskList -parameters $parameters
