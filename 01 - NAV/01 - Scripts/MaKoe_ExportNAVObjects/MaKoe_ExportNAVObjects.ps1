function MaKoe_ExportNAVObjects($databaseServer, $database, $objectPath, $objectsFilter)
{    
    $NAVobjects = Join-Path $objectPath 'NAVobjects.txt'    

    Import-Module "${env:ProgramFiles(x86)}\Microsoft Dynamics NAV\80\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1"

    if ($objectsFilter -eq '')
    {
        Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName $database -DatabaseServer $databaseServer -Path $NAVobjects 
    } else
    {
        Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName $database -DatabaseServer $databaseServer -Path $NAVobjects -Filter $objectsFilter 
    }
   
}

MaKoe_ExportNAVObjects(, , 'C:\TEMP\Test\Test3\')

Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName 'anaptis Develop Administration (7-1)' -DatabaseServer 'NB-T520MK\NAVDEMO' -Path 'C:\TEMP\Test\Test3\NAVobjects.txt' 