## dies müsste aktiviert werden:
# https://myaccount.google.com/security?pli=1#activity
# Weniger sichere Apps zulassen: an

$EmailFrom = "@gmail.com"
$EmailTo = "@gmail.com" 
$Subject = "Notification from XYZ" 
$Body = "this is a notification from XYZ Notifications.."

$username = "googleusername" 
$password = ""

$SMTPServer = "smtp.gmail.com" 
$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587) 
$SMTPClient.EnableSsl = $true 
$SMTPClient.Credentials = New-Object System.Net.NetworkCredential($username, $password); 
$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)