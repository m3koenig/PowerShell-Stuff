#install-module navcontainerhelper -force -ErrorAction Stop
#Write-Host "okay, nav containerhelper is ready!"
#Write-NavContainerHelperWelcomeText

$containerName = "MKODevTest"
$imageName = "mcr.microsoft.com/businesscentral/sandbox"
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

#Mit Console...to-do
#$cnt = 0
#foreach ($tag in $tags) {
#    $cnt += 1
#    Write-Host "[$($cnt)] - $($tag)"
#
#    if (($cnt % 10) -eq 0)
#    {
#        $NextTen = Read-Host -Prompt 'next ten?[Y]'
#        if ($NextTen.ToUpper() -ne "Y")
#        {
#            break;
#        }
#    }
#}
#Write-Host -ForegroundColor Green "$($tags[1])"


New-NavContainer -accept_eula `
    -containerName $containerName `
    -auth NavUserPassword `
    -imageName $choosenImageTag `
    -useBestContainerOS `
    -includeCSide `
    -shortcuts Desktop `
    -enableSymbolLoading `
    -includeTestToolkit `
    -doNotExportObjectsToText `
    -updateHosts `
    -includeTestLibrariesOnly `
    -clickonce `
    -Verbose 


$DesktopPath = [Environment]::GetFolderPath("Desktop")
$containerShortcutFolder = Join-Path $DesktopPath $containerName
if (!(Test-Path $containerShortcutFolder)) {
    New-Item -ItemType directory -Path $containerShortcutFolder 
}

Get-ChildItem $DesktopPath -Filter "*$containerName*.lnk" | 
    ForEach-Object {        
    Move-Item -Path $_.FullName -Destination $containerShortcutFolder -Force 
} 
