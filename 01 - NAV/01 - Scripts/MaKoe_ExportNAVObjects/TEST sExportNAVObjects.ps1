# Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"
# Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1" -force

Export-NAVApplicationObject -DatabaseName 'NAV2015_DEMO' -DatabaseServer 'NB-T520MK\NAVDEMO' -Path 'C:\TEMP\Test\Test3\NAVobjects.txt' -ExportTxtSkipUnlicensed -Filter 'Type=8;ID=90001'