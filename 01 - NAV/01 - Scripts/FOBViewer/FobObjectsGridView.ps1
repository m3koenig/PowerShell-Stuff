## Source: http://www.msdynamics.de/viewtopic.php?f=17&t=28259

function FobObjectsGridView
{
    $FileExists = Test-Path $args
    If ($FileExists -eq $False) {Throw "No $args file exists at this location."}
    $FileExtension = [System.IO.Path]::GetExtension($args)
    if ($FileExtension -eq '.fob')

{
    $DataArray = New-Object System.Collections.Generic.List[object]
    $reader = [System.IO.File]::OpenText($args)
    Write-host "Reading fob header, please wait..."
    try {
        for(;;) {
            $line = $reader.ReadLine()
            if ($line -eq $null) { break }
            $FirstCharacter = $line.Substring(0,1)
            IF ([byte][char]$FirstCharacter -eq 26) { break }
            if ($FirstCharacter -ne ' ')
            {            
            Write-host $line
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
            $DataArray | Out-GridView  -title "Fobviewer $args" 

       }
    }
    else
      {Throw 'Please use a Dynamics NAV object file with *.fob extension for this script.'}
    }



