$CustomerName = "Möbel Meller"
$PostingDate = "25.08.2019"


$filePathToTask = Join-Path $PSScriptRoot "Example.xml"
$xml = New-Object XML
$xml.Load($filePathToTask)

$element =  $xml.SelectSingleNode("//Name")
$element.InnerText = $CustomerName

$element =  $xml.SelectSingleNode("//PostingDate")
$element.InnerText = $PostingDate


$xml.Save($filePathToTask)