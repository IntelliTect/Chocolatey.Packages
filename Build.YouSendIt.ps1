param(
    $taskList,
    $parameters
)
if($parameters -eq $null) { $parameters = @{'packageDirectoryName' = 'YouSendIt'} }

. "$(split-path $myInvocation.MyCommand.Definition)\build.ps1" -taskList $taskList -parameters $parameters
