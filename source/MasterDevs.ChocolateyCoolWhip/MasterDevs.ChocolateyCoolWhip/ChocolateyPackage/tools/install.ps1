#https://github.com/jonnii/BuildDeploySupport/blob/master/package/tools/Init.ps1
#https://robdmoore.id.au/blog/2013/08/07/test-harness-for-nuget-install-powershell-scripts-init-ps1-install-ps1-uninstall-ps1/
# AKA https://github.com/robdmoore/NuGetCommandTestHarness

param($installPath, $toolsPath, $package, $project)
Write-Host "Install Path:  $installPath"
Write-Host "Tools Path:    $toolsPath"
Write-Host "Package:       $package"
Write-Host "Project:       $project"

#-- Import tools for dealing with git
. "$($toolsPath)\FindGitRoot.ps1"

#-- Analyze the environment
$packagePath = Join-Path $toolsPath ".."
$projectPath = Split-Path -Parent $project.FullName
$nuspecTemplatePath = Join-Path $toolsPath "templates\nuspecTemplate.xml"
$nuspectOutputPath = Join-Path $projectPath "$($project.Name).nuspec"
$solutionFolder = Split-Path $dte.Solution.FullName
$gitRoot = findGitRoot -pathInGit $solutionFolder
$appVeyorOutputPath = Join-Path $gitRoot "appveyor.yml"
$appVeyorTemplatePath = Join-Path $toolsPath "templates\appveyor.yml"
$appVeyorContent = Get-Content $appVeyorTemplatePath

$configuration = (Get-Project).ConfigurationManager;
$allReleases = $configuration | where {$_.ConfigurationName -eq "Release"}
$props = $allReleases | Get-Member
$releaseConfiguration = $allReleases
$fullProjectOutputPath = Join-Path $projectPath $releaseConfiguration.Properties.Item("OutputPath").Value
$relativeProjectOutputPath = $fullProjectOutputPath.Replace($solutionFolder, "")
$artifactPath = Join-Path $relativeProjectOutputPath ($project.Name + ".nupkg")

$relativeSolutionPath = $dte.Solution.FullName.Replace($gitRoot, "").SubString(1)

#-- Ensure we can write everything we need
#if([string]::IsNullOrEmpty($gitRoot)) {
#	throw "This project is not using git and therefore this project can not be whipped"
#}

#-- Replace templated items in AppVeyor.yml template
$appVeyorContent = $appVeyorContent.Replace("{{artifactPath}}", $artifactPath)
$appVeyorContent = $appVeyorContent.Replace("{{artifactName}}", $project.Name)
$appVeyorContent = $appVeyorContent.Replace("{{solutionFile}}", $relativeSolutionPath)


#-- Write the appveyor.yml 
Set-Content $appVeyorOutputPath $appVeyorContent
Write-Host "Created " $appVeyorOutputPath

#-- Write the NuSpec file for the project
Copy-Item $nuspecTemplatePath $nuspectOutputPath
Write-Host "Created " $nuspectOutputPath
