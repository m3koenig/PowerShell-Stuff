# Source: https://gallery.technet.microsoft.com/scriptcenter/PowerShell-and-7Zip-83020e74

<#   
This script compress all .bak files {sql backups} in there cureent folder and make new .7zip file. 
  
http://newdelhipowershellusergroup.blogspot.com/2012/01/7zip-and-powershell.htm 
  
http://newdelhipowershellusergroup.blogspot.com 
  
#> 
 
 
#### 7 zip variable I got it from the below link  
 
#### http://mats.gardstad.se/matscodemix/2009/02/05/calling-7-zip-from-powershell/  
# Alias for 7-zip 
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe" 
 
############################################ 
#### Variables  
 
$filePath = "C:\AAA RDP share\tmp" 
 
$bak = Get-ChildItem -Recurse -Path $filePath 
 
########### END of VARABLES ################## 

## All
# $directory = $filePath
# $zipfile = "all.7z" 
# sz a -t7z "$directory\$zipfile" "$directory"    


# Each File
foreach ($file in $bak) { 
                    $name = $file.name 
                    $directory = $file.DirectoryName 
                    $zipfile = $file.BaseName+".7z" 
                    sz a -t7z "$directory\$zipfile" "$directory\$name"      
                } 
 
########### END OF SCRIPT ########## 