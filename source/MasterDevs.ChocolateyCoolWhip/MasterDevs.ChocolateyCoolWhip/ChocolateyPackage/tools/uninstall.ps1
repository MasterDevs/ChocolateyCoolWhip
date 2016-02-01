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
$chocoPath = Join-Path $projectPath "Chocolatey"
$nuspecPath = Join-Path $chocoPath "package.nuspec"

#=======================================
# 3. Clean up
#=======================================
# Delete the nuspec file and the 
# chocolatey folder if it's empty
#=======================================
Remove-Item -Force  $nuspecPath 
echo "Deleted $nuspecPath"

# It would be nice to remove the item from the project as well.

#=======================================
# 4. Done
#=======================================
Write-Host "Done."
