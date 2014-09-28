param(
    $taskList,
    $parameters,
    $packageVersion
)

if(!$packageVersion) { $packageVersion = "v4.0" }
if($parameters -eq $null) { $parameters = @{
    'package' = 'PowerShell'
    'packageVersion' = $packageVersion
    } 
}

. "$(split-path $myInvocation.MyCommand.Definition)\build.ps1" -taskList $taskList -parameters $parameters
