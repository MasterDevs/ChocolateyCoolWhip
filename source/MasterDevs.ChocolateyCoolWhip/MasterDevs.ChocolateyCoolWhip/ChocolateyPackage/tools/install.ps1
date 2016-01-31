#https://github.com/jonnii/BuildDeploySupport/blob/master/package/tools/Init.ps1
#https://robdmoore.id.au/blog/2013/08/07/test-harness-for-nuget-install-powershell-scripts-init-ps1-install-ps1-uninstall-ps1/
# AKA https://github.com/robdmoore/NuGetCommandTestHarness

param($installPath, $toolsPath, $package, $project)
Write-Host "Install Path:  $installPath"
Write-Host "Tools Path:    $toolsPath"
Write-Host "Package:       $package"
Write-Host "Project:       $project"

#=======================================
# 1. Startup
#=======================================
. "$($toolsPath)\FindGitRoot.ps1" # Import git functions
$ErrorActionPreference = "Stop"   # Stop script execution on first error

#=======================================
# 2. Analyze the environment
#=======================================
$packagePath = Join-Path $toolsPath ".."
$projectPath = Split-Path -Parent $project.FullName
$chocoPath = Join-Path $projectPath "Chocolatey"
$solutionFolder = Split-Path $dte.Solution.FullName
$gitRoot = findGitRoot -pathInGit $solutionFolder

$outputAppVeyorPath = Join-Path $gitRoot "appveyor.yml"

$inputNusepcPath =  Join-Path $chocoPath "package.xml"
$outputNuspecPath = Join-Path $chocoPath "package.nuspec"

$templateAppVeyorPath = Join-Path $toolsPath "templates\appveyor.yml"

$templateNuspecPath = Join-Path $toolsPath "templates\nuspecTemplate.xml"

$configuration = (Get-Project).ConfigurationManager;
$allReleases = $configuration | where {$_.ConfigurationName -eq "Release"}
$props = $allReleases | Get-Member
$releaseConfiguration = $allReleases
$fullProjectOutputPath = Join-Path $projectPath $releaseConfiguration.Properties.Item("OutputPath").Value
$relativeProjectOutputPath = $fullProjectOutputPath.Replace($solutionFolder, "")
$artifactPath = Join-Path $relativeProjectOutputPath ($project.Name + ".nupkg")

$relativeSolutionPath = $dte.Solution.FullName.Replace($gitRoot, "").SubString(1)

#=======================================
# 3. Replace Tokens
#=======================================
Write-Host "Replacing tokens"
Write-Host "    Processing AppVeyor.yml"

$tokens = @{
    "{{solutionFile}}"             = $relativeSolutionPath;
    "{{GITHUB_PROJECT_NAME}}"      = "Need to figure this out";
    "{{GITHUB_USERNAME}}"          = "Need to figure this out";
    "{{CHOCOLATEY_PACKAGE_PATH}}"  = $artifactPath;
    "{{SOLUTION_FILE}}"            = $relativeSolutionPath;
    "{{ZIP_ARTIFACT_NAME}}"        = "bin.zip";
    "{{ZIP_ARTIFACT_PATH}}"        = "Must Figure this bit out";
}

$appVeyorContent = Get-Content $templateAppVeyorPath
foreach ($name in $tokens.Keys)
{
    $value = $tokens.Item($name)
    $appVeyorContent = $appVeyorContent.Replace($name, $value)
}

$contentFiles = Get-ChildItem -Recurse -File $chocoPath
foreach ($contentFile in $contentFiles)
{
    Write-Host "    Processing $($contentFile.FullName)"

    $content = Get-Content $contentFile.FullName;

    $content = $content -replace $versionToken, $version
    ForEach($name in $tokens.Keys)
    {
        $value = $tokens.Item($name)
        $content = $content -replace $name, $value;
    }

    Set-Content $contentFile.FullName -Encoding UTF8 $content
}

#=======================================
# 4. Copy over the files
#=======================================
Set-Content $outputAppVeyorPath $appVeyorContent
Write-Host "Installed AppVeyor config file at $outputAppVeyorPath"

#Move-Item -Force $inputNusepcPath $outputNuspecPath

#=======================================
# 5. Done
#=======================================
Write-Host "Done."