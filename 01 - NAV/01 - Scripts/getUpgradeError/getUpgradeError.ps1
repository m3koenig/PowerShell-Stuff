cls

#Prepare PowerShell
Import-Module 'C:\Program Files\Microsoft Dynamics NAV\71\Service\NavAdminTool.ps1'

Get-NAVDataUpgrade -ServerInstance DynamicsNAV80_Dev -ErrorOnly

