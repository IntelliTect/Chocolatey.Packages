param(
    $taskList,
    $parameters
)
if($parameters -eq $null) { $parameters = @{'package' = 'VisualStudio2013Ultimate'} }

. "$(split-path $myInvocation.MyCommand.Definition)\build.ps1" -taskList $taskList -parameters $parameters
