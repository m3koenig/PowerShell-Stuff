
$XMLPath = "http://www.europarl.europa.eu/meps/de/download/advanced/xml?name=&groupCode=&countryCode=DE&constituency=&bodyType=ALL&bodyCode=";
$webClient = New-Object System.Net.WebClient
$webClient.Encoding = [System.Text.Encoding]::UTF8
[xml]$doc = $webClient.DownloadString($XMLPath);


$objs = @()
$nodes = $doc.SelectNodes("meps/mep")
foreach ($node in $nodes) {        
    $fullName = $node.fullName
    $country = $node.country
    $politicalGroup = $node.politicalGroup
    $id = $node.id
    $nationalPoliticalGroup = $node.nationalPoliticalGroup
    
    $TextCulutre = (Get-Culture).TextInfo    
    $potentialMail = $TextCulutre.ToTitleCase($fullName.tolower())

    $potentialMail = $potentialMail.Replace(" ", ".")    
    $potentialMail = $potentialMail.Replace("ä", "ae")
    $potentialMail = $potentialMail.Replace("ö", "oe")
    $potentialMail = $potentialMail.Replace("ü", "ue")
    $potentialMail = $potentialMail.Replace("ß", "ss")
    $potentialMail = $potentialMail.Replace("é", "e")
    $potentialMail = $potentialMail.Replace("É", "e")
    $potentialMail = $potentialMail.Replace("È", "e")
    $potentialMail = $potentialMail.Replace("è", "e")
    $potentialMail = $potentialMail.Replace("á", "a")
    $potentialMail = $potentialMail.Replace("À", "a")
    $potentialMail = $potentialMail.Replace("à", "a")
    $potentialMail = $potentialMail.Replace("À", "a")

    $potentialMail = "$($potentialMail)@europarl.europa.eu"

    $obj = new-object psobject -prop @{FULLNAME=$fullName;COUNTRY=$country;POLITICALGROUP=$politicalGroup;ID=$id;NATIONALPOLITICALGROUP=$nationalPoliticalGroup;POTENTIALMAIL=$potentialMail}
    $objs += $obj
}

$counter = 0;
$allPotentialMails = $null;
$objs | select potentialMail | 
    ForEach-Object{
        $counter ++

        if (![string]::IsNullOrEmpty($allPotentialMails)){
            $allPotentialMails = "$($allPotentialMails);"
        }

        $allPotentialMails = "$($allPotentialMails)$($_.potentialMail)"

    }

Write-Host $allPotentialMails
Write-Host $counter
