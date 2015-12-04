cls

## NAVAdminTool vorher ausführen!
## "C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1"
## geht so leider noch nicht
## invoke-command -filepath "${env:ProgramFiles}\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1" -ComputerName NB-T520mk
 
Publish-NAVApp -ServerInstance DynamicsNAV90 -Path "C:\AAA RDP share\tmp\NAV Extension\CustomerCustomization3.navx"
Install-NAVApp -ServerInstance DynamicsNAV90 -Name ”CustomerCustomization3” 


Get-NAVAppInfo -ServerInstance DynamicsNAV90 -Name 'CustomerCustomization3'

Uninstall-NAVApp -ServerInstance DynamicsNAV90 -Name ”CustomerCustomization3”
Unpublish-NAVApp -ServerInstance DynamicsNAV90 -Name 'CustomerCustomization3'

# oder auch mit Path
## Unpublish-NAVApp -ServerInstance DynamicsNAV90 -Path "C:\AAA RDP share\tmp\NAV Extension\CustomerCustomization3.navx"