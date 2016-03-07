@ECHO OFF
REM ********************************************************************************
REM This script is for debugging chocolatey packaging issues.  It will use the 
REM tokens file to prepare the package then use the chocolatey pack command to 
REM create a chocolatey package with a low version number.
REM
REM To install the package, use the install.bat script
REM
REM Usage:  pack.bat
REM ********************************************************************************

SET BuildVersion=0.0.1
SET APPVEYOR_REPO_TAG_NAME=v%BuildVersion%

ECHO Packaging %APPVEYOR_REPO_TAG_NAME%

powershell .\PrePackage.ps1

cpack --version %BuildVersion% --force
