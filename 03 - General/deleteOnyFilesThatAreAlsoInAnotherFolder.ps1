cls

$onlyFilesThatAreIn = "...\splitted"
$deleteIn = "...\Missing in Custom Base"

$filter = "*.TXT"

Write-Host Delete files in: $deleteIn
Write-Host Files that are in this folder $onlyFilesThatAreIn

Get-ChildItem $onlyFilesThatAreIn -Filter $filter | 
      foreach{

        $currentFileName = "$($_.Name)"
        
        Write-Host File deleted $currentFileName                
        $deleteInPath  = Join-Path $deleteIn $currentFileName        
        Remove-Item -Path $deleteInPath -Force -Recurse

       } 



    