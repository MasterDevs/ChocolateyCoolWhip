# ChocolateyCoolWhip
The coolest way to whip out Chocolatey releases from GitHub and AppVeyor


This is a work-in-progress.


#Useful commands

**Pack**

    cpack --version 1.2.3 --force

**Install**

    cinst bell.portable -yf -s %CD%

**Uninstall**

    cuninst -y bell.portable