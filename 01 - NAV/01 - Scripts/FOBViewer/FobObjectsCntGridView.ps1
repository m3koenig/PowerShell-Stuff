## Source: http://www.msdynamics.de/viewtopic.php?f=17&t=28259
       
function FobObjectsCntGridView
{
    $FileExists = Test-Path $args
    If ($FileExists -eq $False) {Throw "No $args file exists at this location."}
    $FileExtension = [System.IO.Path]::GetExtension($args)
    if ($FileExtension -eq '.fob')
{
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
    $reader = [System.IO.File]::OpenText($args)
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
          {$DataArray | Out-GridView  -title "Fobviewer $args  $OBJCnt Objects ($ObjectList)" -wait}
          else
          {$DataArray | Out-GridView  -title "Fobviewer $args  $OBJCnt Objects ($ObjectList)"}
       }
}
else
  {Throw 'Please use a Dynamics NAV object file with *.fob extension for this script.'}
} 

