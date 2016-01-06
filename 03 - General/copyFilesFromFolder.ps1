$path = "C:\AAA RDP share\"
$destination = "C:\AAA RDP share\NewFolder\"
$filter = "*.CONFLICT"

Get-ChildItem $path -Filter $filter | 
    #%{ 
    foreach{
        $ConflictObject  = "$($_.FullName).txt" -replace ".CONFLICT", "";
        Write-Host  copy file "$($ConflictObject)";
        Copy-Item -path $ConflictObject -Destination $destination -Container -Force -Recurse -Exclude "ConflictMerged";
    } 
        