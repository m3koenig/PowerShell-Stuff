Get-Service -Include "*Dynamics*"| Select-Object Name, Status | Export-Clixml -LiteralPath C:\services.xml 
Start-Process -FilePath "C:\services.xml"



$EndDate=Get-Date
$BeginDate= (Get-Date).AddDays(-7)
Get-WinEvent -FilterHashtable @{
                LogName = "Application"; 
                ProviderName = "MicrosoftDynamicsNavServer`$*";
                StartTime = $BeginDate; 
                EndTime = $EndDate ; 
                Level =2;
                
              } | Export-Clixml -LiteralPath C:\WinEvent.xml 

              Start-Process -FilePath "C:\WinEvent.xml"