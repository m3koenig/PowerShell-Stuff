######
## | Out-GridView 
######

##Get the Application Log
Get-WinEvent -LogName Application -MaxEvents 100
# or read it from a saved log:
# Get-WinEvent -Path "c:\Temp\MySavedLog.evtx" -MaxEvents100
# or from a remote machine:
# Get-WinEvent -MaxEvents 100 -ComputerName MySvr2012
# or from a list of remote machines:
# $Servers="localhost","MySvr2012"
#foreach($Server in $Servers) {$Server ;Get-WinEvent -logname Application -MaxEvents 100 -ComputerName $Server}

## Look for providers
#One of the advantages of Get-WinEvent, is that it filters on source, and only transfers the filtered events back when retrieving events from a remote machine. In the Application Log, Provider = Source. When we are just looking for Dynamics NAV events, then filter on Dynamics NAV. First find the provider / source:
Get-WinEvent -ListProvider *nav* | Format-Table
#Then filter on Dynamics NAV, whether the service you want to check is NAS, Web Service, Dynamics NAV Server, or any other service. For this example let's use "MicrosoftDynamicsNavServer$DynamicsNAV80"
Get-WinEvent -ProviderName "MicrosoftDynamicsNavServer`$DynamicsNAV71" 
#Notice the escape character  ` before the $-sign to tell PowerShell that we want the $-sign, and are not referring to a variable.


##Use FitlerHashTable for filters
#Once we start adding multiple filters to Get-WinEvent, we need to provide them as Key-Value pairs. The supported values for filtering is listed here: Supported Filter Values:
# LogName <String>
# ProviderName <String>
# Path <String>
# Keywords <Long>
# ID <Int32>
# Level <Int32>
# StartTime <DateTime>
# EndTime <DataTime>
# UserID <SID>
# Data <String>
# * <String>
#The syntax is:
# @{Key=Value;Key=Value;etc}
# Example: Look for Application Log entries from Dynamics NAV:
Get-WinEvent -FilterHashtable @{LogName = "Application"; ProviderName = "MicrosoftDynamicsNavServer`$DynamicsNAV71"}

##Useful filters:
#Find error logs: Filter on Level = 2 (Level 4 is Information)
#Date Filters: $MyDate = Get-Date / (Get-Date).AddDays(-2)
#Example: Find Error logs from Dynamics NAV for the last week:
$EndDate=Get-Date
$BeginDate= (Get-Date).AddDays(-7) 
Get-WinEvent -FilterHashtable @{
                LogName = "Application"; 
                ProviderName = "MicrosoftDynamicsNavServer`$DynamicsNAV71" ; 
                StartTime = $BeginDate; 
                EndTime = $EndDate ; 
                Level =2
              } 


## Find specific events
#Find a specific event in the Application Log:
$pattern = "NAS Startup Parameter"#or
$pattern = "The service has registered service principal names "#or
$pattern = "Deadlock"#or
$pattern = "System.InvalidCastException"#or
$pattern = "Server instance: DynamicsNAV71"#or
$pattern = "listening to requests at net.tcp"#... etc
Get-WinEvent -FilterHashtable @{LogName = "Application" ; ProviderName = "MicrosoftDynamicsNavServer`$DynamicsNAV71"} | where {$_.Message.Contains($pattern)} | foreach {"$($_.Message) `n-------`n"}



## Printing details
#You may have noticed that the examples above only print the first few characters of each event. To get the full event (but also mess up your screen), simply format as list:
Get-WinEvent -FilterHashtable @{LogName = "Application" ; ProviderName = "MicrosoftDynamicsNavServer`$DynamicsNAV80"} | Format-List
#or keep it in table format but wrap each line:
Get-WinEvent -FilterHashtable @{LogName = "Application" ; ProviderName = "MicrosoftDynamicsNavServer`$DynamicsNAV80"} | Format-Table -AutoSize -Wrap
# or control the output via a variable:
$Events=  Get-WinEvent -FilterHashtable @{LogName = "Application" ; ProviderName = "MicrosoftDynamicsNavServer`$DynamicsNAV80"}
$Events[1].Message





##########################
## meine Zusammengebauten
##########################
cls
##Useful filters:
#Find error logs: Filter on Level = 2 (Level 4 is Information)
#Date Filters: $MyDate = Get-Date / (Get-Date).AddDays(-2)
#Example: Find Error logs from Dynamics NAV for the last week:
$EndDate=Get-Date
$BeginDate= (Get-Date).AddDays(-7)
 
Get-WinEvent -FilterHashtable @{
                LogName = "Application"; 
                ProviderName = "MicrosoftDynamicsNavServer`$DynamicsNAV71_d3" ; 
                StartTime = $BeginDate; 
                EndTime = $EndDate ; 
                Level =2;
                
              } | Format-Table -AutoSize -Wrap 








 