dir d:\Chocolatey\lib PowerShell.3.0* | %{ rd $_.FullName -recur }
cinst PowerShell -pre -source $pwd
