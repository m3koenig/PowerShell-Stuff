$path = "..\Result"
$destination = "..\Result\OnlyConflicts\"
$filter = "*.CONFLICT"
$cnt = 0

Get-ChildItem $path -Filter $filter | 
    #%{ 
    foreach{
        $ConflictObject  = "$($_.FullName).txt" -replace ".CONFLICT", "";        
        try
        {
            Copy-Item -path $ConflictObject -Destination $destination -Container -Force -Recurse -Exclude "ConflictMerged" -ErrorAction Stop;
            Write-Host copy file "$($ConflictObject)";
            Get-ChildItem -Path $ConflictObject | Select-Object Size
            $cnt += 1
        }
        catch 
        {
            Write-Error "can not copy $($ConflictObject)"
        }
    } 


    Write-Host "$($cnt) files copied!"
        