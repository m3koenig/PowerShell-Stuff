cls

## NAVAdminTool vorher ausführen!
## "C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1"
## geht so leider noch nicht
## invoke-command -filepath "${env:ProgramFiles}\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1" -ComputerName MyComputer
 
Publish-NAVApp -ServerInstance DynamicsNAV90 -Path "c:\tmp\CustomerCustomization3.navx"
Install-NAVApp -ServerInstance DynamicsNAV90 -Name ”CustomerCustomization3” 


Get-NAVAppInfo -ServerInstance DynamicsNAV90 -Name 'CustomerCustomization3'

Uninstall-NAVApp -ServerInstance DynamicsNAV90 -Name ”CustomerCustomization3”
Unpublish-NAVApp -ServerInstance DynamicsNAV90 -Name 'CustomerCustomization3'

# oder auch mit Path
## Unpublish-NAVApp -ServerInstance DynamicsNAV90 -Path "c:\tmp\CustomerCustomization3.navx"