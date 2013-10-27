param(
    $taskList,
    $parameters
)
if($parameters -eq $null) { $parameters = @{'package' = 'VS2012.Ultimate'} }

. "$(split-path $myInvocation.MyCommand.Definition)\build.ps1" -taskList $taskList -parameters $parameters
