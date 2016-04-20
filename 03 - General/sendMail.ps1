# Source: https://github.com/waldo1001/Cloud.Ready.Software.PowerShell

$SMTPServer = ''
$ToAddress =''
$FromAddress = ''
$Subject = 'Test mail from PowerShell'

$Body = "

The Code for this:
---------------------
$SMTPServer = ''
$ToAddress =''
$FromAddress = ''
$Subject = 'Test mail from PowerShell'

$Body = '
No 
Serious 
Body 
content
'

Send-MailMessage -to $ToAddress -From $FromAddress -Subject $Subject -Body $Body -SmtpServer $SMTPServer
---------------------
"

Send-MailMessage -to $ToAddress -From $FromAddress -Subject $Subject -Body $Body -SmtpServer $SMTPServer
