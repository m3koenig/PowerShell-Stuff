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
function Get-MKOBCImage {
    [CmdletBinding()]
    Param (        
        [string]$ImageName="mcr.microsoft.com/businesscentral/sandbox",
        [string]$languageFilter = "de",
        [string]$platformFilter = "ltsc2019"
    )
    
    begin {
    }
    
    process {
        [bool]$ImageNameIsChoosen = $ImageName -like "*:*";

        Write-Verbose "ImageName: $($ImageName)"        
        Write-Verbose "Image already choosen: $($ImageNameIsChoosen)"
        if($ImageNameIsChoosen)
        {
            Write-Host "Image was choosen: $($ImageName)"
            return $ImageName
        }

        Write-Verbose "Load Tags..."
        if ($false -eq [string]::IsNullOrEmpty($platformFilter)) {
            $tags = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { $_.contains($languageFilter) -and $_.contains($platformFilter) }
        }
        else {
            $tags = (Get-NavContainerImageTags -imageName $imageName).Tags | Where-Object { $_.contains($languageFilter) }
        }

        #mit Gui
        $choosenImageTag = $tags | Sort-Object -Descending | Out-GridView -PassThru -Title "Choose your Image of $($ImageName)"
        if ([string]::IsNullOrEmpty($choosenImageTag) -eq $true) {
            Write-Error "No image selected..." -ErrorAction Stop
        }
        $choosenImageTag = "$($ImageName):$($choosenImageTag)"
        return $choosenImageTag
    }
    
    end {
    }
}