## Nur ein Beispiel, kein vollfunktionsfähiges Script

$FromFile = 'C:\temp\inputNavObjects.txt'
$ToFile = 'C:\temp\inputNavObjects_Renumberd.txt'

## Leider noch nicht so genau, daher erst einmal wieder auskommentiert
# $Table50000To = '60000'
# $Table50001To = '60001'
# $Table50004To = '60004'
# 
# $Codeunit50000To = '60000'
# $Codeunit50003To = '60003'
# 
# $Page50001To = '60001'
# $Page50003To = '60003'
# $Page50004To = '60004'
# $Page50005To = '60005'
# $Page50006To = '60006'

$Object50000To = '70000'
$Object50001To = '70001'
$Object50003To = '70003'
$Object50004To = '70004'
$Object50005To = '70005'
$Object50006To = '70006'




(Get-Content $FromFile) -replace '50000', $Object50000To | Set-Content $ToFile
(Get-Content $ToFile) -replace '50001', $Object50001To | Set-Content $ToFile
(Get-Content $ToFile) -replace '50003', $Object50003To | Set-Content $ToFile
(Get-Content $ToFile) -replace '50004', $Object50004To | Set-Content $ToFile
(Get-Content $ToFile) -replace '50005', $Object50005To | Set-Content $ToFile
(Get-Content $ToFile) -replace '50006', $Object50006To | Set-Content $ToFile


## hier konnte ich nicht mehere Zeilen auf einmal verändern
# (Get-Content $FromFile) | 
# Foreach-Object{
# $_ -replace '50000', $Object50000To,
# }  | 
# Out-File $ToFile -Encoding ascii