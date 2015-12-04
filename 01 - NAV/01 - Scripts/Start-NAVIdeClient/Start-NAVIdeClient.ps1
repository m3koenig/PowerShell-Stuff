Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"

function Start-NAVIdeClient
{
    [cmdletbinding()]
    param(
        [string]$ServerName, 
        [String]$Database
        )
 
    if ([string]::IsNullOrEmpty($NavIde)) {
        Write-Error "Please load the AMU (NavModelTools) to be able to use this function"
    }
 
    $Arguments = "servername=$ServerName, database=$Database, ntauthentication=yes"
    Write-Verbose "Starting the DEV client $Arguments ..."
    Start-Process -FilePath $NavIde -ArgumentList $Arguments 
}


