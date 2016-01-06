cls

$path = "C:\AAA RDP share\"
$filter = "*.CONFLICT"

Get-ChildItem $path -Filter $filter | 
      #%{ 
      foreach{
        $currentFileWithConcat = "$($_.FullName).txt" -replace ".CONFLICT", ""
        Write-Host  $currentFileWithConcat
       } 



    