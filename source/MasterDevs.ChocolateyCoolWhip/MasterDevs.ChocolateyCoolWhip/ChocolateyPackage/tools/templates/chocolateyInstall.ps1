﻿$packageName = 'bell.portable' # arbitrary name for the package, used in messages
$url ="https://dl.dropboxusercontent.com/u/140634/Bell.zip"

try 
{
  $installDir = Join-Path $env:AllUsersProfile "$packageName"
  Write-Host "Adding `'$installDir`' to the path and the current shell path"
  Install-ChocolateyPath "$installDir"
  $env:Path = "$($env:Path);$installDir"

  Install-ChocolateyZipPackage "$packageName" "$url" "$installDir"
} 
catch 
{
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
