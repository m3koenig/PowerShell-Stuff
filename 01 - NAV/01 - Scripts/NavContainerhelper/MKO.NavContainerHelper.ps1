#update-module  navcontainerhelper -force -ErrorAction Stop
#install-module navcontainerhelper -force -ErrorAction Stop
#update-module navcontainerhelper -force -ErrorAction Stop
#Write-Host "okay, nav containerhelper is ready!"
#Write-NavContainerHelperWelcomeText

$containerName = "mkodev"
$imageName = "mcr.microsoft.com/businesscentral/sandbox"
#$imageName = "mcr.microsoft.com/businesscentral/sandbox:14.0.29537.31313-de-ltsc2019"
$languageFilter = "de"
$platformFilter = "ltsc2019"

if ([string]::IsNullOrEmpty($platformFilter) -eq $false) {
    $tags = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { $_.contains($languageFilter) -and $_.contains($platformFilter)}
}
else {
    $tags = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { $_.contains($languageFilter)}
}

#mit Gui
$choosenImageTag = $tags | Sort-Object -Descending | Out-GridView -PassThru -Title "Choose your Image of $($imageName)" 
if ([string]::IsNullOrEmpty($choosenImageTag) -eq $true) {
    Write-Error "No image selected..." -ErrorAction Stop
}
$choosenImageTag = "$($imageName):$($choosenImageTag)"

New-NavContainer -accept_eula -containerName $containerName -auth NavUserPassword -imageName $choosenImageTag -useBestContainerOS -accept_outdated -shortcuts Desktop -enableSymbolLoading -dumpEventLog -includeTestToolkit -doNotCheckHealth -isolation hyperv -doNotExportObjectsToText -updateHosts -includeTestLibrariesOnly -additionalParameters @("--env CustomNavSettings=EnableThreadThrottling=False,nablePrioritizedThreadThrottling=False") -Verbose 


$DesktopPath = [Environment]::GetFolderPath("Desktop")
$containerShortcutFolder = Join-Path $DesktopPath $containerName
if (!(Test-Path $containerShortcutFolder)) {
    New-Item -ItemType directory -Path $containerShortcutFolder 
}

Get-ChildItem $DesktopPath -Filter "*$containerName*.lnk" | 
    ForEach-Object {        
    Move-Item -Path $_.FullName -Destination $containerShortcutFolder -Force 
} 
