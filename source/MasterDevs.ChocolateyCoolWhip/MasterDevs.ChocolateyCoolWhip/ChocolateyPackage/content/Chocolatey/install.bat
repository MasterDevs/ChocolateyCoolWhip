@ECHO OFF
REM ********************************************************************************
REM This script is for debugging chocolatey packaging issues.  it will install 
REM the local chocolatey package.  You may need to uninstall an existing package.
REM
REM To create the local package, use the pack.bat script
REM To uninstall the package when you are done just use the uninstall.bat script
REM
REM Usage:  install.bat
REM ********************************************************************************

cinst {{GITHUB_PROJECT_NAME}}.portable -yf -s %CD%
