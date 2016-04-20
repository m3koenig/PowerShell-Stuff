﻿$OriginalPath = ""

Merge-NAVApplicationObject `
    -OriginalPath $OriginalPath `
$cnt = 0

Write-Host "start to copy conflict objects of"
Write-Host $ResultPath
Get-ChildItem $ResultPath -Filter $filter |     
    foreach{
        $ConflictObject  = "$($_.FullName).txt" -replace ".CONFLICT", "";  
              
        $ConflictObjectDestination  = "$($_.BaseName).txt" -replace "COD", "Codeunit";
        $ConflictObjectDestination  = "$($ConflictObjectDestination)" -replace "TAB", "Table";
        $ConflictObjectDestination  = "$($ConflictObjectDestination)" -replace "PAG", "Page";
        $ConflictObjectDestination  = "$($ConflictObjectDestination)" -replace "REP", "Report";

        $ConflictObjectDestinationFullName = Join-Path $OnlyConflictsFilePath $ConflictObjectDestination        
        Write-Host -ForegroundColor DarkGray "copy file $($ConflictObject)";
        Write-Host -ForegroundColor Green "to file $($ConflictObjectDestinationFullName)"
        try
        {
            Copy-Item -path $ConflictObject -Destination $ConflictObjectDestinationFullName -Container -Force -Recurse -Exclude "OnlyConflicts" -ErrorAction Stop;            
            Get-ChildItem -Path $ConflictObject | Select-Object Size
            $cnt += 1
        }
        catch
        {
            Write-Error "can not copy $($ConflictObject)!"
        }
    } 


Write-Host "$($cnt) files copied!"