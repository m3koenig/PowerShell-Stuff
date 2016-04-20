                                
function NAV.CreateNAVEnviromentForSQLBAK {
    [CmdLetBinding()]
    param(
        [string] $DatabaseServer = [net.dns]::gethostname(),
        [String] $DatabaseInstance = '',
        [string] $DatabaseName = $(throw 'Please specify a database name.'),
        [string] $SQLBAKFile = $(throw 'Please specify a SQL BAK file.'),        
        [string] $NSTInstanceName,
        [int]$ManagementServicesPort,
        [int]$ClientServicesPort,
        [int]$ODataServicesPort,
        [int]$SOAPServicesPort,
        [string] $NAVVersion="2016"  
      )

    # This function is needed
    $RootPath = Split-Path (Split-Path $PSScriptRoot -Parent) -Parent
    $SQLDatabaseExists = Join-Path $RootPath  "02 - SQL\02 - Functions\SQL.DatabaseExists.ps1"
    Import-Module $SQLDatabaseExists
    write-host -foregroundcolor DarkGray "Script $($SQLDatabaseExists) loaded."   

    $SQLInvoke = Join-Path $RootPath  "02 - SQL\02 - Functions\SQL.Invoke.ps1"
    Import-Module $SQLInvoke
    write-host -foregroundcolor DarkGray "Script $($SQLInvoke) loaded."   

    $SQLBackupFromFile= Join-Path $RootPath  "02 - SQL\02 - Functions\SQL.BackupFromFile.ps1"
    Import-Module $SQLBackupFromFile
    write-host -foregroundcolor DarkGray "Script $($SQLBackupFromFile) loaded."   

    Write-Verbose "PSScriptRoot: $($PSScriptRoot)"
    Write-Verbose "RootPath: $($RootPath)"
    Write-Verbose "SQLDatabaseExists: $($SQLDatabaseExists)"
    Write-Verbose "SQLInvoke: $($SQLInvoke)"
    Write-Verbose "SQLBackupFromFile: $($SQLBackupFromFile)"

    



    ## Needed NAV Sources 90=2016
    if ($NAVVersion -eq "2015"){
        $VersionCode = "80"
    }

    if ($NAVVersion -eq "2016"){
        $VersionCode = "90"
    }

    write-Host -ForegroundColor DarkGray "Load NAV PS Tools from Version $($NAVVersion)/$($VersionCode)..."
    Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$($VersionCode)\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1" -WarningAction SilentlyContinue | out-null
    Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($VersionCode)\Service\NavAdminTool.ps1" -WarningAction SilentlyContinue | Out-Null

    if ($NSTInstanceName -ne '') 
    {
        write-verbose "install without service tier!"
        if ($ManagementServicesPort -eq 0){
            $(throw 'Please specify a ManagementServicesPort.')
            return 
        }

        if ($ClientServicesPort -eq 0) 
        { 
            $(throw 'Please specify a ClientServicesPort.')
            return 
        }

        if ($ODataServicesPort -eq 0) 
        {
            $(throw 'Please specify a ODataServicesPort.')
            return 
        }

        if ($SOAPServicesPort -eq 0)
        {
            $(throw 'Please specify a SOAPServicesPort.')
            return 
        }
    }

    $DatabaseServerWithInstance = $DatabaseServer;
    if ($DatabaseInstance -ne '')
    {
        $DatabaseServerWithInstance = $DatabaseServerWithInstance + "\" + $DatabaseInstance
    }

    write-Host -ForegroundColor DarkGray "Restore SQL bak $($SQLBAKFile) file into database..."    
    ## New-NAVDatabase $SQLBAKFile -DestinationPath $DatabaseFileDestination -DatabaseName $DatabaseName -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -verbose | fl    
    ##########################
    SQL.BackupFromFile -BackupFile $SQLBAKFile -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $DatabaseName 

    #$CreateServiceAccountUser = “CREATE USER [NT AUTHORITY\NETWORK SERVICE] FOR LOGIN [NT AUTHORITY\NETWORK SERVICE]”
    #Invoke-Sqlcmd -ServerInstance $MySQLServerName -Database $MyNewDatabaseName -Query $CreateServiceAccountUser
    #$AddServiceAccountAsDbo = “exec sp_addrolemember ‘db_owner’, ‘NT AUTHORITY\NETWORK SERVICE'”
    #Invoke-Sqlcmd -ServerInstance $MySQLServerName -Database $MyNewDatabaseName -Query $AddServiceAccountAsDbo


    ##########################
    if (-not (SQL.DatabaseExists -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $DatabaseName -Verbose)) {
        # $PSCmdlet.WriteError($Global:Error[0])
        $(throw 'Database ' + $DatabaseName + ' on '+$DatabaseServer+'/'+$DatabaseInstance+' does not exist!')
        return 
    }    
    
    write-Host -ForegroundColor Green "Database $($DatabaseName) restored"

    if ($NSTInstanceName -ne '') 
    {

        write-Host -ForegroundColor DarkGray "Install service tier instance..."
        New-NAVServerInstance -ServerInstance $NSTInstanceName -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName $DatabaseName -ManagementServicesPort $ManagementServicesPort -ClientServicesPort $ClientServicesPort -ODataServicesPort $ODataServicesPort -SOAPServicesPort $SOAPServicesPort -ServiceAccount NetworkService -Verbose
        write-Host -ForegroundColor Green "Service tier instance installed!"


        write-Host -ForegroundColor DarkGray "Start service tier instance..."
        Set-NAVServerInstance $NSTInstanceName -Start -verbose
        write-Host -ForegroundColor Green "Service tier instance started!"
        # or
        # start-service "MicrosoftDynamicsNAVServer*MyNewNAV90ServerInstance"

        # Get-NAVServerInstance $NSTInstanceName | Out-GridView
        write-Host -ForegroundColor Green "New NAV service tier instance installed!"
    }

    write-Host -ForegroundColor Green "Your new NAV environment is ready!"
    write-Host -ForegroundColor Green "> SQLBAKFile: $($SQLBAKFile)"
    write-Host -ForegroundColor Green "> DatabaseServer: $($DatabaseServer)"
    write-Host -ForegroundColor Green "> DatabaseInstance: $($DatabaseInstance)"
    write-Host -ForegroundColor Green "> DatabaseName: $($DatabaseName)"    
    if ($NSTInstanceName -ne '')
    {
        write-Host -ForegroundColor Green "> NSTInstanceName: $($NSTInstanceName)"
    }
     
 
   return 
}