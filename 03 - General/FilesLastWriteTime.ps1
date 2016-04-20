#Logging
Function Logging ($Log, $State, $Message) {
    $CurrentDate=Get-Date -format dd.MM.yyyy-HH:mm:ss

    if ($Log -eq "")
    {
        return
    }

    if (!(Test-Path -Path $Log)) {
        New-Item -Path $Log -ItemType File -Force | Out-Null
    }
    $Text="$CurrentDate - $State"+":"+" $Message"

    # if ($LoggingLevel -eq "1" -and $Message -notmatch "was copied") {Write-Host $Text}
    # elseif ($LoggingLevel -eq "3" -and $Message -match "was copied") {Write-Host $Text}
   
    add-Content -Path $Log -Value $Text
}

function BackupFiles {
    [CmdLetBinding()]
    param(
        [string] $Backup = $(throw 'Please specify a Backup folder.'),
        [String] $Backupdir = $(throw 'Please specify a Backupdir folder.'),
        [int] $MaxBackupFileByte,
        [DateTime]$FromDateTime,
        [DateTime]$ToDateTime
      )

    # $FromDateTime = Get-Date $FromDateTime -Format dd.MM.yyyy    
    # $ToDateTime = Get-Date $ToDateTime -Format dd.MM.yyyy;
    
    Write-Verbose "Parameter"
    Write-Verbose "---------------"
    Write-Verbose "To backup: $($Backup)"
    Write-Verbose "Backup Directory: $($Backupdir)"
    Write-Verbose "From DateTime: $($FromDateTime)"
    Write-Verbose "To DateTime: $($ToDateTime)"
    Write-Verbose "MaxBackupFileByte: $($MaxBackupFileByte)"
    Write-Verbose "---------------"
        
    [bool]$BackupdirCreated = $false;

    if ($ToDateTime -ne $null)
    {
        # $Backupdir = "$($Backupdir)\$($ToDateTime.Year)$($ToDateTime.Month)$($ToDateTime.Day)"
        $Backupdir = "$($Backupdir)\$(Get-Date $ToDateTime -Format yyyMMdd)"
        $Log = "Log-$($ToDateTime.Year)$($ToDateTime.Month)$($ToDateTime.Day).txt"

    } else
    {
        $Backupdir = "$($Backupdir)\$(Get-Date -Format yyyMMdd)-Total"        
        $Log = "Log-$((Get-Date).Year)$((Get-Date).Month)$((Get-Date).Day)-Total.txt"

        [DateTime]$FromDateTime = '01/01/2000 00:00:00'
        [DateTime]$ToDateTime = '12/31/3000 23:59:59'

        Write-Verbose "From and ToDateTime converted because ToDateTime has no value:"
        Write-Verbose "FromDateTime: $($FromDateTime)"
        Write-Verbose "ToDateTime: $($ToDateTime)"
    }

    if ($ToDateTime.TimeOfDay -eq $FromDateTime.TimeOfDay)
    {
        $ToDateTime = $ToDateTime.AddDays(1).AddSeconds(-1);
        Write-Verbose "From and ToDateTime is the same.ToDateTime converted to next day one second earlier:"        
        Write-Verbose "ToDateTime: $($ToDateTime)"
    }

    Write-Verbose "Full Backupdir: $($Backupdir)"
    Write-Verbose "Logfile: $($Log)"

    Logging $Log "INFO" $Log

    # Show Items with lastWriteTime
    # Select-Object FullName, LastWriteTime, @{Name="Mbytes";Expression={$_.Length/1Kb}}, @{Name="Age in Days";Expression={(((Get-Date) - $_.LastWriteTime).Days)}} 

    Write-Verbose "Detect files ..."

    # Nur Dateien und die dazugehörigen Ordner
    Get-ChildItem $Backup -Recurse -Force| 
    Where-Object {($_.LastWriteTime -ge $FromDateTime) -and ($_.LastWriteTime -lt $ToDateTime)}  |
        ForEach-Object{   
            if ($_.Attributes -ne "Directory")
            {
                $lengthOK = ($_.Length -le $MaxBackupFileByte) -or ($MaxBackupFileByte -eq $null) -or ($MaxBackupFileByte -eq 0);
                IF ($lengthOK)
                {
                    Write-Verbose ">Found File: $($_.FullName), $($_.LastWriteTime)"
                    try{            
                        if ($BackupdirCreated -eq $false)
                        {
                            New-Item -Path $Backupdir -ItemType Directory -ErrorAction SilentlyContinue  
                            $BackupdirCreated = $true;
                            Move-Item -Path $Log -Destination $Backupdir -Force
                            $Log = Join-Path $Backupdir $Log
                            Logging $Log "INFO" "----------------------"
                            Logging $Log "INFO" "Start the Script"
                        }
            
                           
                        $newDir = $_.FullName.Replace($Backup, $null).Replace($_.Name, $null);
                        New-Item -Path $Backupdir$newDir -ItemType Directory -ErrorAction SilentlyContinue                      
                        $fullBackupItemName = Join-Path $Backupdir $newDir        
                        Copy-Item $_.FullName -destination $fullBackupItemName; 
                        Logging $Log "BACKUP-FILE-DONE" $_.FullName
                    }catch
                    {
                        Logging $Log "BACKUP-FILE-ERROR" $_.FullName+" - "+$_.Exception.Message
                    }
                }
            }else
            {
                try
                {
                    $newDir = $_.FullName.Replace($Backup, $null);
                    New-Item -Path $Backupdir$newDir -ItemType Directory -ErrorAction SilentlyContinue                      
                    Logging $Log "BACKUP-DIR-DONE" $_.FullName
                }catch
                {
                    Logging $Log "BACKUP-DIR-ERROR" $_.FullName+" - "+$_.Exception.Message
                }
            }
        } 
            
    Logging $Log "INFO" "End the Script"
    Logging $Log "INFO" "----------------------"
}

Set-ExecutionPolicy -ExecutionPolicy Unrestricted
BackupFiles -Backup 'C:\Tools' -Backupdir "d:\Backup\Tools" -FromDateTime (get-Date).Date -ToDateTime (get-Date).Date.AddDays(1).AddSeconds(-1)
# BackupFiles -Backup 'C:\Tools' -Backupdir "d:\Backup\Tools" -FromDateTime '03/02/2016' -ToDateTime '03/02/2016' -MaxBackupFileByte 0 -Verbose

