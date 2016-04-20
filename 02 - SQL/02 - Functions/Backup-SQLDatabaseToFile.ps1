#Source: http://stackoverflow.com/questions/8423541/how-do-you-run-a-sql-server-query-from-powershell
function Invoke-SQL {
    [CmdLetBinding()]
    param(
        [string] $DatabaseServer = [net.dns]::gethostname(),
        [String] $DatabaseInstance = '',
        [string] $DatabaseName = 'Master',
        [string] $SQLCommand = $(throw 'Please specify a query.')
      )

    if (!([string]::IsNullOrEmpty($DatabaseInstance))){
        $DatabaseServer = "$($DatabaseServer)\$($DatabaseInstance)"
    }
    $connectionString = "Data Source=$DatabaseServer; Integrated Security=SSPI; Initial Catalog=$DatabaseName"

    write-Host -ForegroundColor Green "Invoke-SQL with this statement on database '$DatabaseName':"
    Write-Host -ForegroundColor Gray $SQLCommand

    $connection = new-object system.data.SqlClient.SQLConnection($connectionString)
    $command = new-object system.data.sqlclient.sqlcommand($sqlCommand,$connection)    
    $connection.Open()

    $adapter = New-Object System.Data.sqlclient.sqlDataAdapter $command
    $dataset = New-Object System.Data.DataSet
    $adapter.Fill($dataSet) | Out-Null

    $connection.Close()
    $connection.Dispose()

    $dataSet.Tables
     
}

# Source: https://github.com/waldo1001/Cloud.Ready.Software.PowerShell
function Backup-SQLDatabaseToFile
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$false)]
        [System.String]
        $DatabaseServer = '.',
        
        [Parameter(Mandatory=$false)]
        [System.String]
        $DatabaseServerInstance = 'MSSQLSERVER',
        
        [Parameter(Mandatory=$true)]
        [System.String]
        $DatabaseName,
        
        [Parameter(Mandatory=$false)]
        [System.String]
        $BackupFile = "$DatabaseName.bak"

        # MKO001-a
        ,
        [Parameter(Mandatory=$false)]
        [System.String]
        $Backuplocation = $RegKey.GetValue('BackupDirectory')
        # MKO001+
    )
    

    $BaseReg = [Microsoft.Win32.RegistryKey]::OpenRemoteBaseKey('LocalMachine', $DatabaseServer)
    $RegKey  = $BaseReg.OpenSubKey('SOFTWARE\\Microsoft\\Microsoft SQL Server\\Instance Names\\SQL')
    $SQLinstancename = $RegKey.GetValue($DatabaseServerInstance)
    $RegKey  = $BaseReg.OpenSubKey("SOFTWARE\\Microsoft\\Microsoft SQL Server\\$SQLInstancename\\MSSQLServer")

    # MKO001-
    # $Backuplocation = $RegKey.GetValue('BackupDirectory')
    # MKO001+
     
    $BackupFileFullPath = Join-Path $Backuplocation $BackupFile     

    Write-Host -ForegroundColor Green "Backuplocation: $($Backuplocation)"
    Write-Host -ForegroundColor Green "BackupFile: $($BackupFile)"
    Write-Host -ForegroundColor Green "BackupFileFullPath: $($BackupFileFullPath)"

    # $Backuplocation = $RegKey.GetValue('BackupDirectory')
    # $BackupFileFullPath = Join-Path $Backuplocation $BackupFile    
    # Write-Host -ForegroundColor Green "BackupFileFullPath2: $($BackupFileFullPath)"

    $SQLString = "BACKUP DATABASE [$DatabaseName] TO  DISK = N'$BackupFileFullPath' WITH  COPY_ONLY, NOFORMAT, INIT,  NAME = N'NAVAPP_QA_MT-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10"
    
    write-Host -ForegroundColor Green "Backup up database $Database ..."
    
    invoke-sql -DatabaseServer $DatabaseServer -sqlCommand $SQLString

    Get-Item $BackupFileFullPath
}

