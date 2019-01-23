install-module navcontainerhelper -force -ErrorAction Stop
Write-Host "okay, nav containerhelper is ready!"
Write-NavContainerHelperWelcomeText




New-NavContainer -accept_eula -containerName "MKODevTest" -auth NavUserPassword -imageName "mcr.microsoft.com/businesscentral/sandbox:de-ltsc2019" -useBestContainerOS -includeCSide -shortcuts Desktop -enableSymbolLoading -includeTestToolkit -doNotExportObjectsToText -updateHosts -includeTestLibrariesOnly -clickonce -Verbose