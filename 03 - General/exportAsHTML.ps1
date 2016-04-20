Get-Service -Include "*Dynamics*" | ConvertTo-HTML -Property Name, Status > C:\services.htm
Start-Process -FilePath "C:\services.htm"

$EndDate=Get-Date
$BeginDate= (Get-Date).AddDays(-7)
Get-WinEvent -FilterHashtable @{
                LogName = "Application"; 
                ProviderName = "MicrosoftDynamicsNavServer`$*";
                StartTime = $BeginDate; 
                EndTime = $EndDate ; 
                Level =2;
                
              } | ConvertTo-HTML -Property ProviderName, TimeCreated, Message   >  C:\WinEvent.htm 

Start-Process -FilePath "C:\WinEvent.htm"