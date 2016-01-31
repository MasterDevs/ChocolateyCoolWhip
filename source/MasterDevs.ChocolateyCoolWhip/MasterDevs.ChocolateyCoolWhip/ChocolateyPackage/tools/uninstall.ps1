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
$projectPath = Split-Path -Parent $project.FullName

$inputNusepcPath =  Join-Path $projectPath "Chocolatey\package.xml"
$outputNuspecPath = Join-Path $projectPath "Chocolatey\package.nuspec"

#=======================================
# Rename files so they match what they came in as
#=======================================

Move-Item -Force  $outputNuspecPath $inputNusepcPath

#=======================================
# 5. Done
#=======================================
Write-Host "Done."