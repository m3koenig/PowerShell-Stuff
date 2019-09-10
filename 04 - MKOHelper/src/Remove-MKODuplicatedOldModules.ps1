<#
.SYNOPSIS
    Deletes older versions of powershell modules
.DESCRIPTION
    If there are two or more versions of a powershell module, its checks the highest version and deletes the other.
.EXAMPLE
    # removes all duplicated versions
    Remove-MKODuplicatedOldModules 
.NOTES
    #source: http://sharepointjack.com/2017/powershell-script-to-remove-duplicate-old-modules/
#>
function Remove-MKODuplicatedOldModules {
    [CmdletBinding()]
    param (
        
    )
    
    begin {
        Write-Verbose "this will remove all old versions of installed modules"
        Write-Verbose "be sure to run this as an admin"
        Write-Verbose "(You can update all your Azure RM modules with update-module Azurerm -force)"

        $ModsInstalled = get-installedmodule
        [int]$UninstalledOldVersions = 0;

        foreach ($Mod in $ModsInstalled) {
            Write-Verbose "Checking $($mod.name)"            
            $latest = get-installedmodule $mod.name
            
            $specificmods = get-installedmodule $mod.name -allversions
            try {
                $specificmodsCount = $specificmods.count
            }
            catch {
                $specificmodsCount = 0;
            }
            Write-Verbose "$($specificmodsCount) versions of this module found [ $($mod.name) ]"
        
            foreach ($sm in $specificmods) {
                if ($sm.version -ne $latest.version) {
                    write-Verbose "uninstalling $($sm.name) - $($sm.version) [latest is $($latest.version)]"
                    $sm | uninstall-module -force
                    $UninstalledOldVersions += 1;
                    write-Verbose "done uninstalling $($sm.name) - $($sm.version)"                 
                }
            
            }            
        }
        write-host "$($UninstalledOldVersions) uninstalled old modules!"
    }
    
    process {   
    }
    
    end {
    }
}