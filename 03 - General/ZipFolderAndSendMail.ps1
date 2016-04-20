#### 7 zip variable I got it from the below link  
 
#### http://mats.gardstad.se/matscodemix/2009/02/05/calling-7-zip-from-powershell/  
# Alias for 7-zip 
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe" 
 
############################################ 
#### Variables  
 
$filePath = "C:\AAA RDP share" 
 
$bak = Get-ChildItem -Recurse -Path $filePath 
 
########### END of VARABLES ################## 

## All
$directory = $filePath
$zipfile = "all.7z" 
sz a -t7z "$directory\$zipfile" "$directory"    

# Source: https://github.com/waldo1001/Cloud.Ready.Software.PowerShell

$SMTPServer = ''
$ToAddress =''
$FromAddress = ''
$Subject = 'Folder is Zipped'

$Body = "FOLDER IS ZIPPED!"

Send-MailMessage -to $ToAddress -From $FromAddress -Subject $Subject -Body $Body -SmtpServer $SMTPServer