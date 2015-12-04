cls

Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools2.psd1"

# $databaseServer = 'SQLServer\NAVDEMO'
$databaseServer = Read-Host 'DatabaseServer'
# $database = 'NAV2015_Dev'
$database = Read-Host 'Database'

# $SearchString = 'Search'
$SearchString = Read-Host 'Search'

$objectPath = Read-Host 'Save NAV Object Path'

$sourcepath = Join-Path $ObjectPath '\MyObjects' 
$NAVobjects = Join-Path $ObjectPath 'NAVobjects.txt'
$LogPath = Join-Path $ObjectPath '\log\whereused.txt'


# Export the objects you like, either all objects:
Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName $database -DatabaseServer $databaseServer -Path $NAVobjects 

# Or filter (choose the filter you like):
# $FilterString = "Version List=*SHORTCUT*"
#or
# $FilterString = "Modified=Yes"
# Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName $database -DatabaseServer $databaseServer -Path $NAVobjects -Filter $FilterString 


#Split into individual object files
split-navapplicationobjectfile -Source $NAVobjects -Destination $sourcepath -PassThru -Force
$myobjects = Get-ChildItem -Path $sourcepath -Filter *txt -File

# cls 
$myobjects | Select-String $SearchString | Out-File –Filepath $LogPath
$myobjects | Select-String $SearchString | Out-GridView 
