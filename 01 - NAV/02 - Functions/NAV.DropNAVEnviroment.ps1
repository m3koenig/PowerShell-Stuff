function NAV.DropNAVEnviroment {
    [CmdLetBinding()]
    param(
        [string] $DatabaseServer = [net.dns]::gethostname(),
        [String] $DatabaseInstance = '',
        [string] $DatabaseName = $(throw 'Please specify a database name.'),                
        [string] $NSTInstanceName = $(throw 'Please specify a Navision Service Tier instance name.')
                
      )
      
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") | Out-Null
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoExtended") | Out-Null
    [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.ConnectionInfo") | Out-Null
    [Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SmoEnum") | Out-Null
     
    ## Needed NAV Sources 90=2016
    Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1' -WarningAction SilentlyContinue | out-null
    Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1' -WarningAction SilentlyContinue | Out-Null

    ## Removes Serverstier
    write-Host -ForegroundColor DarkGray "Remove service tier $($NSTInstanceName)..."
    Remove-NAVServerInstance $NSTInstanceName -force
    write-Host -ForegroundColor Green "Service tier $($NSTInstanceName) removed!"

    ## DROP SQL Database if Exists     
    if (!([string]::IsNullOrEmpty($DatabaseInstance))){
        $FullSQLServer = "$($DatabaseServer)\$($DatabaseInstance)"
    }
    write-Host -ForegroundColor DarkGray "Drop database $($Databasename) of the SQL Server $($FullSQLServer)) if exists..."

    $smoserver = New-Object ( "Microsoft.SqlServer.Management.Smo.Server" ) $FullSQLServer
    
    if ($smoserver.Databases[$Databasename]) {
        $smoserver.KillAllProcesses($Databasename)
        $smoserver.Databases[$Databasename].drop() 
        write-Host -ForegroundColor Green "Database $($Databasename) of the SQL Server $($FullSQLServer)) droped!"
    }else
    {
        Write-Host "Database $($Databasename) not exists!"
    }

    write-Host -ForegroundColor Green "NAV Enviroment droped!"    
    write-Host -ForegroundColor Green "> DatabaseServer: $($DatabaseServer)"
    write-Host -ForegroundColor Green "> DatabaseInstance: $($DatabaseInstance)"
    write-Host -ForegroundColor Green "> DatabaseName: $($DatabaseName)"    
    write-Host -ForegroundColor Green "> NSTInstanceName: $($NSTInstanceName)"
     
    return 
}