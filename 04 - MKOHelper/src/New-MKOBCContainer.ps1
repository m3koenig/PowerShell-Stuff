<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
    Example of how to use this cmdlet
.NOTES
    General notes
#>
function New-MKOBCContainer {
    [CmdletBinding()]
    Param (
        [string]$ContainerName = "mkodev",
        [string]$ImageName = "mcr.microsoft.com/businesscentral/sandbox:14.1.32615.0-de-ltsc2019",    
        [string]$languageFilter = "de",
        [string]$platformFilter = "ltsc2019"
    )

    begin {        
        Write-Verbose "Load Imagename ($($ImageName))"
        $choosenImageTag = Get-MKOBCImage -ImageName $ImageName -languageFilter $languageFilter  -platformFilter $platformFilter

        Write-Verbose "Create container $($ContainerName))"
        #New-NavContainer -accept_eula -containerName $ContainerName -auth NavUserPassword -imageName $choosenImageTag -useBestContainerOS -accept_outdated -shortcuts Desktop -enableSymbolLoading -dumpEventLog -includeTestToolkit -doNotCheckHealth -isolation hyperv -doNotExportObjectsToText -updateHosts -includeTestLibrariesOnly -additionalParameters @("--env CustomNavSettings=EnableThreadThrottling=False,nablePrioritizedThreadThrottling=False") -Verbose
        New-NavContainer -accept_eula -containerName $ContainerName -auth NavUserPassword -imageName $choosenImageTag -useBestContainerOS -accept_outdated -shortcuts Desktop -enableSymbolLoading -dumpEventLog -doNotCheckHealth -isolation hyperv -doNotExportObjectsToText -updateHosts -includeTestLibrariesOnly -additionalParameters @("--env CustomNavSettings=EnableThreadThrottling=False,nablePrioritizedThreadThrottling=False") -Verbose

        Write-Verbose "Move Inks to separate folder..."
        Move-MKOContainerInksToFolder -ContainerName $ContainerName

        Write-Verbose "Done!"
        
    }

    process {


    }

    end {
    }
}