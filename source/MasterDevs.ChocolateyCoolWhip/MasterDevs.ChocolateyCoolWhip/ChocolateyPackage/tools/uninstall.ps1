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

# Remove nuspec from the csproj

foreach ($top in $project.ProjectItems | where-object { $_.Name -EQ "Chocolatey" }) 
{
    foreach ($child in $top.ProjectItems | Where-Object { $_.Name -EQ "package.nuspec" } ) 
    {
        $child.Remove()
    }
}

# Delete the nuspec file
Remove-Item -Force  $nuspecPath 
echo "Deleted $nuspecPath"


#=======================================
# 4. Done
#=======================================
Write-Host "Done."
