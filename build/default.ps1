properties {
    [Parameter(Mandatory=1)]
    $package
}
task default -depends SetParams,Build,Test

[string]$here=split-path $myInvocation.MyCommand.Definition
[string]$packageDirectoryPath = $null
[string]$nuspecFile= $null
[string]$outputFileName
[string]$outputDirectoryPath=$null
[string]$outputFilePath=$null
[string]$packageVersion=$null

task SetParams { 
	Assert ($package -ne $null) "`$package should not be null. Run with -parameters @{'package' = 'PowerShell';} for example."
    $script:packageDirectoryPath="$here\..\$package"
    if($packageVersion) { 
        if($packageVersion -notmatch "v\d\.\d") {
            throw "`$packageVersion is invalid.  It must match a format such as v4.0."
        } 
        else {
            $script:packageDirectoryPath = (Join-Path $script:packageDirectoryPath $packageVersion)
        }
    }
    $nuspecFiles=@(Get-ChildItem $script:packageDirectoryPath -recurse -include *.nuspec -Exclude .\tools)
    Assert($nuspecFiles.Count -eq 1) "There is more than one nuspec file in the package directory: @{$nuspecFiles}"
    $script:nuspecFile = $nuspecFiles[0].FullName
    [xml]$script:nuspec=(type $script:nuspecFile)
    $script:outputFileName=("{0}.{1}.nupkg" -f $script:nuspec.package.metadata.id, $script:nuspec.package.metadata.version)
    $script:outputDirectoryPath="$here\..\bin"
    if(!(test-path $script:outputDirectoryPath)) { new-item -itemtype directory -path $script:outputDirectoryPath }
    $script:outputFilePath=$(join-path $script:outputDirectoryPath $script:outputFileName)
}

task Clean { 
    Get-ChildItem  $script:packageDirectoryPath -Recurse -include *.swp,*.*~ | Remove-Item
    Remove-Item $script:outputFilePath
}

task Build -depends SetParams { 
    #TODO: Boostrap NuGet
    #TODO: Create Output Directory Property.
    #TODO: Determine a means to avoid script scope if possible?
    $nuget = (get-command Nuget -erroraction silentlycontinue)
    if($nuget -eq $null) {$nuget = get-command (join-path $env:chocolateyinstall "chocolateyInstall\NuGet.exe")}
    . $NuGet Pack $script:nuspecFile -OutputDirectory $script:outputDirectoryPath -BasePath $script:packageDirectoryPath -Exclude **\*.swp`;**\*.*~
}

task Test -depends SetParams {
    Invoke-Pester "$here\..\" $package
}

task ViewPackage -depends SetParams {
    7za l $script:outputFilePath
}