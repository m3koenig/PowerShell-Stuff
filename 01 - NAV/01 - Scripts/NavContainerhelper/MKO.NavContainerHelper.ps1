install-module navcontainerhelper -force -ErrorAction Stop
Write-Host "okay, nav containerhelper is ready!"
Write-NavContainerHelperWelcomeText

#$imageName = "mcr.microsoft.com/businesscentral/sandbox"
#$tags = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { $_.contains("de") -and  $_.contains("13")}
#$tags |Format-Table


#New-NavContainer -accept_eula -containerName "MKODevTest" -auth NavUserPassword -imageName "mcr.microsoft.com/businesscentral/sandbox:de-ltsc2019" -useBestContainerOS -includeCSide -shortcuts Desktop -enableSymbolLoading -includeTestToolkit -doNotExportObjectsToText -updateHosts -includeTestLibrariesOnly -clickonce -Verbose

#$MyParameters = @{
#    accept_eula = $true
#    containerName = "MKODevTest" 
#    auth = "NavUserPassword"
#    imageName = "mcr.microsoft.com/businesscentral/sandbox:de-ltsc2019" 
#    useBestContainerOS = $true
#    includeCSide = $true
#    shortcuts = "Desktop"
#    enableSymbolLoading = $true
#    includeTestToolkit = $true
#    doNotExportObjectsToText = $true
#    updateHosts = $true
#    includeTestLibrariesOnly = $true
#    clickonce = $true
#    Verbose = $true
#}
#
#
#New-NavContainer $MyParameters 

New-NavContainer -accept_eula -containerName "MKODevTest" -auth NavUserPassword -imageName "mcr.microsoft.com/businesscentral/sandbox:de" -useBestContainerOS -includeCSide -shortcuts Desktop -enableSymbolLoading -includeTestToolkit -doNotExportObjectsToText -updateHosts -includeTestLibrariesOnly -clickonce -Verbose 