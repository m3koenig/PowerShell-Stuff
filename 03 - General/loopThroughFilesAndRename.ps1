$path = "...\Result"
$destination = "...\splitted Final\"
$filter = "*.txt"

Get-ChildItem $path -Filter $filter | 
    #%{ 
    foreach{
        $ConflictObject  = "$($_.BaseName).txt" -replace "COD", "Codeunit";
        $ConflictObject  = "$($ConflictObject)" -replace "TAB", "Table";
        $ConflictObject  = "$($ConflictObject)" -replace "REP", "Report";
        $ConflictObject  = "$($ConflictObject)" -replace "PAG", "Page";
        Write-Host copy file "$($ConflictObject)";

        $ToObject = Join-Path -path $destination -ChildPath $ConflictObject
        Write-Host to file "$($ToObject)";
        

        Copy-Item -path "$($_.FullName)" -Destination $ToObject -Container -Force -Recurse 
    } 
