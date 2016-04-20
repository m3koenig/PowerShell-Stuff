<# The sample scripts are not supported under any Microsoft standard support 
 program or service. The sample scripts are provided AS IS without warranty  
 of any kind. Microsoft further disclaims all implied warranties including,  
 without limitation, any implied warranties of merchantability or of fitness for 
 a particular purpose. The entire risk arising out of the use or performance of  
 the sample scripts and documentation remains with you. In no event shall 
 Microsoft, its authors, or anyone else involved in the creation, production, or 
 delivery of the scripts be liable for any damages whatsoever (including, 
 without limitation, damages for loss of business profits, business interruption, 
 loss of business Information, or other pecuniary loss) arising out of the use 
 of or inability to use the sample scripts or documentation, even if Microsoft 
 has been advised of the possibility of such damages 
#>

$loop = New-JobTrigger -Once -At 6:00am -RepetitionDuration(New-TimeSpan -Days 365) -RepetitionInterval(New-TimeSpan -Minutes 30) 
Register-ScheduledJob -Name sendMailTestMKO -FilePath "C:\AAA RDP share\Tools\02 - PowerShell\Powershell-Lab\03 - General\CreateJobScheduler\sendMail.ps1" -Trigger $loop 

Get-JobTrigger sendMailTestMKO

Get-JobTrigger -Name sendMailTestMKO | Disable-JobTrigger
Get-JobTrigger -Name sendMailTestMKO | Enable-JobTrigger

Remove-JobTrigger -Name sendMailTestMKO
Unregister-ScheduledJob sendMailTestMKO
