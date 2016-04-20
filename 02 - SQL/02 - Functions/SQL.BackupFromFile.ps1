# Source GitHub Cloud.Ready.Software.PowerShell

function SQL.BackupFromFile
{

    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory=$true)]
        [System.String]
        $BackupFile,
        [Parameter(Mandatory=$false)]
        [System.String]
        $DatabaseServer = '.',

        [Parameter(Mandatory=$false)]
        [System.String]
        $DatabaseInstance = '',
        
        [Parameter(Mandatory=$true)]
        [System.String]
        $DatabaseName,
        
        [Parameter(Mandatory=$false)]
        [System.String]
        $DatabaseDataPath = '',

        [Parameter(Mandatory=$false, Position=2)]
        [System.String]
        $DatabaseLogPath = ''
    )
    
    if ([String]::IsNullOrEmpty($DatabaseDataPath)){
        $SQLString = "SELECT [Default Data Path] = SERVERPROPERTY('InstanceDefaultDataPath')"
        $DatabaseDataPath = (SQL.Invoke -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -sqlCommand $SQLString)."Default Data Path"
    }
    if ([String]::IsNullOrEmpty($DatabaseLogPath)){
        $SQLString = "SELECT [Default Log Path] = SERVERPROPERTY('InstanceDefaultLogPath')"
        $DatabaseLogPath = (SQL.Invoke -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -sqlCommand $SQLString)."Default Log Path"
    }
    $SQLString = "RESTORE FILELISTONLY FROM DISK=N'$BackupFile'"
    
    $DatabaseFileList = SQL.Invoke -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -sqlCommand $SQLString
    
    $RestoreSQLString = "RESTORE DATABASE [$DatabaseName] FROM DISK = N'$BackupFile' WITH FILE = 1,
    "
    foreach ($File in $DatabaseFileList){
        if ($File.Type -eq 'L') {
            $DatabaseFile = (join-path $DatabaseLogPath ($DatabaseName + "_$($File.FileId)" + [io.path]::GetExtension($File.PhysicalName)) ) 
        } else {
            $DatabaseFile = (join-path $DatabaseDataPath ($DatabaseName + "_$($File.FileId)"  + [io.path]::GetExtension($File.PhysicalName)) ) 
        }
        $RestoreSQLString += "MOVE N'$($File.LogicalName)' TO N'$($DatabaseFile)',
        "
    }
    $RestoreSQLString += 'NOUNLOAD, REPLACE, STATS = 5'

    write-Host -ForegroundColor Green "Restoring database $DatabaseName"
        
    #SQL.Invokecmd -ServerInstance $DatabaseServer -Database 'master' -Query $RestoreSQLString -QueryTimeout 600000
    SQL.Invoke -DatabaseServer $DatabaseServer -DatabaseInstance $DatabaseInstance -DatabaseName 'master' -sqlCommand $RestoreSQLString    
}

