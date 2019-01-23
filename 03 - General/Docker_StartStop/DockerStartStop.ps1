Write-Host "------"
Get-Service "*Docker*" | sort Status
Write-Host "------"

$startServices = Read-Host "Sollen die Docker Dienste gestartet oder gestoppt werden?[J=Starten;N=Stoppen]";
$startServices = $startServices.ToUpper();


if ($startServices -eq 'J')
{
    $stoppedDockerServices = Get-Service "*docker*" | Where-Object {$_.Status -EQ "Stopped"} 
    foreach($dockerService in $stoppedDockerServices) {   
        Write-Host -ForegroundColor Green "$($dockerService.DisplayName) wird gestartet..."     
        start-Service $dockerService -Verbose
    }
}else {
    $startedDockerServices = Get-Service "*docker*" | Where-Object {$_.Status -EQ "Running"} 
    foreach($dockerService in $startedDockerServices) {
        Write-Host -ForegroundColor Red "$($dockerService.DisplayName) wird beendet..."     
        Stop-Service $dockerService -Verbose
    }
    
}
   


