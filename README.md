# ChocolateyCoolWhip   [![Build status](https://ci.appveyor.com/api/projects/status/6r12na0ulbe7q7s2/branch/master?svg=true)](https://ci.appveyor.com/project/jquintus/chocolateycoolwhip/branch/master) [![NuGet version](https://badge.fury.io/nu/ChocolateyCoolWhip.svg)](https://www.nuget.org/packages/ChocolateyCoolWhip/)


The coolest way to whip out Chocolatey releases from GitHub and AppVeyor


This is a work-in-progress.


#Useful commands

**Pack**

    cpack --version 1.2.3 --force

**Install**

    cinst bell.portable -yf -s %CD%

**Uninstall**

    cuninst -y bell.portable
