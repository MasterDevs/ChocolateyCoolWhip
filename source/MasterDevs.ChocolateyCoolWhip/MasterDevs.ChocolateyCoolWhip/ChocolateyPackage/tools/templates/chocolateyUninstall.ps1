$packageName = 'bell.portable' 
$zipName = "bell.exe"

try 
{
  $installDir = Join-Path $env:AllUsersProfile "$packageName"
  Uninstall-ChocolateyZipPackage "$packageName" "$zipName" 
  Remove-Item -Recurse -Force "$installDir"
} 
catch 
{
  Write-ChocolateyFailure "$packageName" "$($_.Exception.Message)"
  throw
}
