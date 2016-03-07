@ECHO OFF
REM ********************************************************************************
REM This script is for debugging chocolatey packaging issues.  it will uninstall 
REM the existing chocolatey package.  It can be used before or after (most times 
REM both) the install.bat
REM
REM Usage:  uninstall.bat
REM ********************************************************************************

cuninst -y {{GITHUB_PROJECT_NAME}}.portable
