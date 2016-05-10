function NAV.ExportObjectsOfFob {
    [CmdLetBinding()]
    param(

        [string] $databaseServer, 
        [string] $database, 
        [string] $fobPath, 
        [string] $exportPath,
        [string] $NAVVersion="2016" 
        )    

    $FileExists = Test-Path $fobPath
    If ($FileExists -eq $False) {Throw "No $fobPath file exists at this location."}
    $FileExtension = [System.IO.Path]::GetExtension($fobPath)
    if ($FileExtension -eq '.fob') {

        ## Needed NAV Sources 90=2016
        if ($NAVVersion -eq "2015"){
            $VersionCode = "80"
        }

        if ($NAVVersion -eq "2016"){
            $VersionCode = "90"
        }

        write-Host -ForegroundColor DarkGray "Load NAV PS Tools from Version $($NAVVersion)/$($VersionCode)..."
        Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$($VersionCode)\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1" -WarningAction SilentlyContinue | out-null
        Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($VersionCode)\Service\NavAdminTool.ps1" -WarningAction SilentlyContinue | Out-Null


        [int]$OBJCnt = 0
        [int]$TABCnt = 0
        [int]$FORCnt = 0
        [int]$PAGCnt = 0
        [int]$REPCnt = 0
        [int]$DATCnt = 0
        [int]$CODCnt = 0
        [int]$QUECnt = 0
        [int]$XMLCnt = 0
        [int]$MENCnt = 0

        $DataArray = New-Object System.Collections.Generic.List[object]
        $reader = [System.IO.File]::OpenText($fobPath)
        Write-host "Reading fob header, please wait..."
        try {
            for(;;) {
                $line = $reader.ReadLine()
                if ($line -eq $null) { break }
                $FirstCharacter = $line.Substring(0,1)
                IF ([byte][char]$FirstCharacter -eq 26) { break }
                $ShortObjectType = $line.Substring(0,3).ToUpper()
                Switch ($ShortObjectType)
                {
                "TAB" {$TABCnt++}
                "PAG" {$PAGCnt++}
                "REP" {$REPCnt++}
                "COD" {$CODCnt++}
                "QUE" {$QUECnt++}
                "XML" {$XMLCnt++}
                "MEN" {$MENCnt++}
                "FOR" {$FORCnt++}
                "DAT" {$DATCnt++}
                }
                if ($FirstCharacter -ne ' ')
                {           
                $OBJCnt++
                $ObjectType = $line.Substring(0,9).Trim()
                $ObjectID = $line.Substring(10,10).Trim()
                $ObjectName = $line.Substring(21,30)
                $ObjectDate = $line.Substring(54,10).Trim()
                $ObjectTime = $line.Substring(70,8).Trim()
                }
                else
                {
                $ObjectSize = $line.Substring(10,10)
                $ObjectVersion = $line.Substring(21,57)
                $Obj =  New-Object Psobject -Property @{
                    Type= $ObjectType
                    ID =  $ObjectID
                    Name = $ObjectName
                    Date = $ObjectDate
                    Time = $ObjectTime
                    Size = $ObjectSize
                    Version = $ObjectVersion
                        }
                    $DataArray.add($Obj)

                }
            }
        }
        finally {
            $reader.Close()
            if ($TABCnt -gt 0) {$ObjectList += "TAB:$TABCnt "}
            if ($FORCnt -gt 0) {$ObjectList += "FOR:$FORCnt "}
            if ($PAGCnt -gt 0) {$ObjectList += "PAG:$PAGCnt "}
            if ($REPCnt -gt 0) {$ObjectList += "REP:$REPCnt "}
            if ($DATCnt -gt 0) {$ObjectList += "DAT:$DATCnt "}
            if ($CODCnt -gt 0) {$ObjectList += "COD:$CODCnt "}
            if ($QUECnt -gt 0) {$ObjectList += "QUE:$QUECnt "}
            if ($XMLCnt -gt 0) {$ObjectList += "XML:$XMLCnt "}
            if ($MENCnt -gt 0) {$ObjectList += "MEN:$MENCnt "}
      
        
            if ($host.name -eq 'ConsoleHost') 
            {
                # $DataArray | Out-GridView  -title "Fobviewer $fobPath  $OBJCnt Objects ($ObjectList)" -wait
        
            }
            else
            {
                # $DataArray | Out-GridView  -title "Fobviewer $fobPath  $OBJCnt Objects ($ObjectList)"        
            }
            $objectFilter ='';
                $objectTypes = 'Table','Page','Report','Codeunit','Query','XMLport','MenuSuite'	        
	            foreach($objectType in $objectTypes)
	            {
                    ## if ($objectFilter -ne ""){
                    ##     $objectFilter = "$($objectFilter);"
                    ## }
                    # $objectFilter = "$($objectFilter)$($ObjectType)"
                    $objectFilter = "$($ObjectType)"


                    $objectIDFilter = ""
                    ## Write-Host "objectFilter $($objectFilter)"
                    foreach($Object in $DataArray)
                    {
                        if ($Object.Type -eq $objectType)
                        {
                            if ($objectIDFilter -ne ""){
                                $objectIDFilter = "$($objectIDFilter)|"
                            }
                            $objectIDFilter = "$($objectIDFilter)$($Object.id)"
                            # Write-Host "$($ObjectType) $($objectIDFilter)"
                        }
                    }
                    if ($objectIDFilter -ne "")
                    {                       
                        $objectFilter = "Type=$($objectFilter);ID=$($objectIDFilter)"
                        Export-NAVApplicationObject -ExportTxtSkipUnlicensed -DatabaseName $database -DatabaseServer $databaseServer -Path "$($exportPath)\$($objectType)-Objects.txt" -Filter $objectFilter -Force
                    }
	            }
        
                $splitted = "$($exportPath)\SplittedObjects"
                New-Item -Path $splitted -ItemType directory
                $filter = "*.txt"
                Get-ChildItem $exportPath -Filter $filter |         
                foreach{
                    Write-Host $_.FullName
                    Split-NAVApplicationObjectFile -Source $_.FullName -Destination "$($splitted)\" -Force
                } 
          }
        } else {
            Throw 'Please use a Dynamics NAV object file with *.fob extension for this script.'
        } 

}

# Aufruf:
NAV.ExportObjectsOfFob -databaseServer "NB\NAVDEMO" -database "Demo Database NAV (9-0) 2" -fobPath "C:\TMP\someStdObjects-mko-std-160510-1400.fob" -exportPath "C:\TMP\ExportFromFob"