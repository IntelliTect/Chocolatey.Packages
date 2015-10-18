[CmdletBinding(DefaultParameterSetName="Package")]
param(
    [ValidateScript({Test-Path $_ -PathType Leaf})][Parameter(Mandatory,ParameterSetName="nuspecFilePath")][string]$nuspecFilePath,
    [ValidateScript({$_.TrimStart(".\") -in (Get-ChildItem $PSScriptRoot -Exclude bin,build,.git -Directory).Name})][Parameter(Mandatory,ParameterSetName="Package")][string]$Package
)

Function Create-ChocolateyPackage {
    [CmdletBinding(DefaultParameterSetName="Package")]
    param(
    [ValidateScript({Test-Path $_ -PathType Leaf})][Parameter(Mandatory,ParameterSetName="nuspec")][string]$nuspecFilePath,
    [ValidateScript({$_.TrimStart(".\") -in (Get-ChildItem $PSScriptRoot -Exclude bin,build,.git -Directory).Name})][Parameter(Mandatory,ParameterSetName="Package")][string]$Package
    )

    if($PsCmdlet.ParameterSetName -eq "Package") {
        $nuspecFilePath = (Get-ChildItem (Join-path $PSScriptRoot $Package) *.nuspec -Recurse)[-1] | Select-Object -ExpandProperty FullName
    }

    [bool]$packageCreatedSuccessfully=$false
    [string]$packOutput = Choco Pack $nuspecFilePath 
    $packOutput| %{ ` # -OutputDirectory doesn't appear to work, file is instead output to current directory. 
        if($_ -match "Successfully created package '(?'NugetFile'.*)'") {
            $packageCreatedSuccessfully = $true
            Write-Output $Matches.NugetFile
        }
    } | %{
        Get-ChildItem .\ $_ 
    } | %{
        Move-Item $_.FullName "$PSScriptRoot\bin\"  -Force  # Overwrite the file if it already exists
        Get-Item (Join-Path "$PSScriptRoot\bin\"  (Split-Path $_ -Leaf))  #Write the resulting nuget file to the output stream.
    }

    if(!$packageCreatedSuccessfully) { Throw $packOutput.ToString() }
}

switch($PSCmdlet.ParameterSetName) {
    "Package" {
        Create-ChocolateyPackage -Package $Package
    }
    "nuspecFilePath" {
        Create-ChocolateyPackage -nuspecFilePath $nuspecFilePath
    }
}
