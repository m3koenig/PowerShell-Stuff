Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"

function Start-NAVWindowsClient
{
    [cmdletbinding()]
    param(
        [string]$ServerName, 
        [int]$Port, 
        [String]$ServerInstance, 
        [String]$Companyname, 
        [string]$tenant='default'
        )
 
    if ([string]::IsNullOrEmpty($Companyname)) {
       $Companyname = (Get-NAVCompany -ServerInstance $ServerInstance -Tenant $tenant)[0].CompanyName
    }
 
    $ConnectionString = "DynamicsNAV://$Servername" + ":$Port/$ServerInstance/$MainCompany/?tenant=$tenant"
    Write-Verbose "Starting $ConnectionString ..."
    Start-Process $ConnectionString
}

Start-NAVWindowsClient -ServerName "NB-T520MK\NAVDEMO" -Port 8046 -ServerInstance "dynamicsnav80_dev" -Companyname "CRONUS AG"