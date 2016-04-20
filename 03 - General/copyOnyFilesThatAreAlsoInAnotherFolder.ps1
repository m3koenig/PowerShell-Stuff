cls

$onlyFilesThatAreIn = "...\Target\splitted"
$copyFrom = "...\07 - 2016 Std + Module\splitted"
$copyTo = "...\Missing in Custom Base ZV"

$filter = "*.TXT"

Write-Host Copy files from: $copyFrom
Write-Host Files that are in this folder $onlyFilesThatAreIn
Write-Host Copy files to: $copyTo

Get-ChildItem $onlyFilesThatAreIn -Filter $filter | 
      foreach{

        $currentFileName = "$($_.Name)"
        
        Write-Host File copied $currentFileName        

        $copyFromPath = Join-Path $copyFrom $currentFileName
        $copyToPath  = Join-Path $copyTo $currentFileName

        Copy-Item -path $copyFromPath -Destination $copyToPath -Container -Force -Recurse
        

       } 



    