Get-Service -Include "*Dynamics*"| Select-Object Name, Status | Export-Csv -Delimiter ";" -LiteralPath C:\services.Csv 
Start-Process -FilePath "C:\services.csv"


$EndDate=Get-Date
$BeginDate= (Get-Date).AddDays(-7)
Get-WinEvent -FilterHashtable @{
                LogName = "Application"; 
                ProviderName = "MicrosoftDynamicsNavServer`$*";
                StartTime = $BeginDate; 
                EndTime = $EndDate ; 
                Level =2;
                
              } | Export-Csv -Delimiter ";" -LiteralPath C:\WinEvent.Csv 

              Start-Process -FilePath "C:\WinEvent.csv"