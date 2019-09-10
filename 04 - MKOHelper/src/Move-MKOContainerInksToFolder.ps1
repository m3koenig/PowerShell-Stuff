<#
.SYNOPSIS
    Short description
.DESCRIPTION
    Long description
.EXAMPLE
.NOTES
    General notes
#>
function Move-MKOContainerInksToFolder {
    [CmdletBinding()]    
    Param (        
        [Parameter(Mandatory)]
        [string]$ContainerName
    )
    
    begin {
    }
    
    process {
        $DesktopPath = [Environment]::GetFolderPath("Desktop")
        $containerShortcutFolder = Join-Path $DesktopPath $ContainerName
        if (!(Test-Path $containerShortcutFolder)) {
            New-Item -ItemType directory -Path $containerShortcutFolder
        }
        
        Get-ChildItem $DesktopPath -Filter "*$containerName*.lnk" |
        ForEach-Object {
            Move-Item -Path $_.FullName -Destination $containerShortcutFolder -Force
        }
    }
    
    end {
    }
}


