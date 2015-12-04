function NAV.CreateNAVEnviromentForSQLBAK {
    [CmdLetBinding()]
    param(
        [string] $DatabaseServer = [net.dns]::gethostname(),
        [String] $DatabaseInstance = '',
        [string] $DatabaseName = $(throw 'Please specify a database name.'),
        [string] $SQLBAKFile = $(throw 'Please specify a SQL BAK file.'),
        [string] $DatabaseFileDestination = $(throw 'Please specify a database destination.'),
        [string] $NSTInstanceName = $(throw 'Please specify a Navision Service Tier instance name.')
                
      )

    # This function is needed
    $RootPath = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $SQLDatabaseExists = "$($RootPath)\02 - SQL\02 - Functions\SQL.DatabaseExists.ps1"
    Import-Module $SQLDatabaseExists
    write-verbose "Script $($SQLDatabaseExists) loaded."

    # Needed NAV Sources 90=2016
    Import-Module 'C:\Program Files (x86)\Microsoft Dynamics NAV\90\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1' -WarningAction SilentlyContinue | out-null
    Import-Module 'C:\Program Files\Microsoft Dynamics NAV\90\Service\NavAdminTool.ps1' -WarningAction SilentlyContinue | Out-Null
  

    write-Host -ForegroundColor DarkGray "Restore SQL bak $($SQLBAKFile) file into database..."
    New-NAVDatabase $SQLBAKFile -DestinationPath $DatabaseFileDestination -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -verbose | fl    
    if (-not (SQL.DatabaseExists -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $DatabaseName -Verbose)) {
        # $PSCmdlet.WriteError($Global:Error[0])
        return 
    }    
    write-Host -ForegroundColor Green "Database $($DatabaseName) restored"

    write-Host -ForegroundColor DarkGray "Install service tier instance..."
    New-NAVServerInstance -ServerInstance $NSTInstanceName -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $DatabaseName -ManagementServicesPort 9245 -ClientServicesPort 9246 -ODataServicesPort 9247 -SOAPServicesPort 9248 -ServiceAccount NetworkService -Verbose
    write-Host -ForegroundColor Green "Service tier instance installed!"


    write-Host -ForegroundColor DarkGray "Start service tier instance..."
    Set-NAVServerInstance $NSTInstanceName -Start -verbose
    write-Host -ForegroundColor Green "Service tier instance started!"
    # or
    # start-service "MicrosoftDynamicsNAVServer*MyNewNAV90ServerInstance"

    # Get-NAVServerInstance $NSTInstanceName | Out-GridView
    write-Host -ForegroundColor Green "New NAV service tier instance installed!"

    write-Host -ForegroundColor Green "Your new NAV environment is ready!"
    write-Host -ForegroundColor Green "> SQLBAKFile: $($SQLBAKFile)"
    write-Host -ForegroundColor Green "> DatabaseServer: $($DatabaseServer)"
    write-Host -ForegroundColor Green "> DatabaseInstance: $($DatabaseInstance)"
    write-Host -ForegroundColor Green "> DatabaseName: $($DatabaseName)"
    write-Host -ForegroundColor Green "> DatabaseFileDestination: $($DatabaseFileDestination)"
    write-Host -ForegroundColor Green "> NSTInstanceName: $($NSTInstanceName)"
     
    return 
}