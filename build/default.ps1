properties {
    [Parameter(Mandatory=1)]
    $packageDirectoryName
}


task default -depends SetParams,Build

[string]$scriptPath=split-path $myInvocation.MyCommand.Definition
[string]$packageDirectoryPath = $null
[string]$nuspecFile= $null
[string]$outputFileName
[string]$outputDirectoryPath=$null
[string]$outputFilePath=$null

task SetParams { 
	Assert ($packageDirectoryName -ne $null) "`$packageDirectoryName should not be null. Run with -parameters @{'packageDirectoryName' = 'PowerShell';} for example."
    $script:packageDirectoryPath="$scriptPath\..\$packageDirectoryName"
    $nuspecFiles=@(Get-ChildItem $script:packageDirectoryPath -recurse -include *.nuspec -Exclude .\tools)
    Assert($nuspecFiles.Count -eq 1) "There is more than one nuspec file in the package directory: @{$nuspecFiles}"
    $script:nuspecFile = $nuspecFiles[0].FullName
    [xml]$script:nuspec=(type $script:nuspecFile)
    $script:outputFileName=("{0}.{1}.nupkg" -f $nuspec.package.metadata.id, $nuspec.package.metadata.version)
    $script:outputDirectoryPath="$scriptPath\..\bin"
    if(!(test-path $script:outputDirectoryPath)) { new-item -itemtype directory -path $script:outputDirectoryPath }
    $script:outputFilePath=$(join-path $script:outputDirectoryPath $script:outputFileName)
}

task Clean { 
    Get-ChildItem  $script:packageDirectoryPath -Recurse -include *.swp,*.*~ | Remove-Item
    Remove-Item $script:outputFilePath
}

task Build { 
    #TODO: Boostrap NuGet
    #TODO: Create Output Directory Property.
    #TODO: Determine a means to avoid script scope if possible?
    NuGet Pack $script:nuspecFile -OutputDirectory $script:outputDirectoryPath -BasePath $script:packageDirectoryPath -Exclude **\*.swp`;**\*.*~
}

task ViewPackage -depends SetParams {
    7za l $script:outputFilePath
}