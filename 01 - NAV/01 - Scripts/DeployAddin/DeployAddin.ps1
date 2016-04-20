## Parameter
[bool]$RestartNST = $false;
[bool]$CloseLocalDevEnv = $true;
[bool]$CloseLocalWinClient = $true;

[bool]$StartLocalDevEnv = $true;
[bool]$StartLocalWinClient = $true;


$AddInName = "NAVanaptisCalendar"

$SQLServer = "NB-T520MK\NAVDEMO"
$ServerName = ""
$NAVServiceTier = ""
$NAVDatabase = "Demo Database NAV (9-0) 2"
$RunPageAtStart = 50001 # 50000

$VSProjectPath = "c:\users\koenig\documents\visual studio 2013\Projects\My Add-in"
$AddInDLL = $VSProjectPath+"\bin\Debug"
$AddInDLL = "$($AddInDLL)\$($AddInName).dll"

$NAVVersion="2016" 
## Needed NAV Sources 90=2016
if ($NAVVersion -eq "2015"){
    $VersionCode = "80"
}

if ($NAVVersion -eq "2016"){
    $VersionCode = "90"
}

$ToWinClientAddFolder = "C:\Program Files (x86)\Microsoft Dynamics NAV\"+$VersionCode+"\RoleTailored Client\Add-ins\MyAddins"
$AddInRessourceFolder = $VSProjectPath+"\Resource"
$AddInRessourceZipFolder = "$($AddInRessourceFolder)\Manifest.zip" 


write-Host -ForegroundColor DarkGray "Load NAV PS Tools from Version $($NAVVersion)/$($VersionCode)..."
Import-Module "C:\Program Files (x86)\Microsoft Dynamics NAV\$($VersionCode)\RoleTailored Client\Microsoft.Dynamics.Nav.Model.Tools.psd1" -WarningAction SilentlyContinue | out-null
Import-Module "C:\Program Files\Microsoft Dynamics NAV\$($VersionCode)\Service\NavAdminTool.ps1" -WarningAction SilentlyContinue | Out-Null
write-Host -ForegroundColor DarkGray ">Done"

## Needed Functions
Function GetToken()
{
	Param(
		[string]$file
	)

	return -join ([Reflection.AssemblyName]::GetAssemblyName($file).GetPublicKeyToken() `
		| foreach { $_.ToString("X2").ToLower() })
}

$token = GetToken -file $AddInDLL



Function ZipFolder()
{
	Param(
		[string]$Folder
	)

	Add-Type -Assembly "System.IO.Compression.FileSystem"
	$dest = [System.IO.Path]::GetTempFileName()
	[System.IO.File]::Delete($dest)
	[System.IO.Compression.ZipFile]::CreateFromDirectory($Folder, $dest)
	return $dest
}


function Start-NAVIdeClient
{
    [cmdletbinding()]
    param(
        [string]$ServerName, 
        [String]$Database
        )
 
    if ([string]::IsNullOrEmpty($NavIde)) {
        Write-Error "Please load the AMU (NavModelTools) to be able to use this function"
    }
 
    $Arguments = "servername=$ServerName, database=$Database, ntauthentication=ja"
    Write-Verbose "Starting the DEV client $Arguments ..."
    Start-Process -FilePath $NavIde -ArgumentList $Arguments 
}

function Start-NAVWindowsClientPage
{
    [cmdletbinding()]
    param(
        [string]$ServerName, 
        [int]$Port, 
        [String]$ServerInstance, 
        [String]$Companyname,         
        [int]$pageID
        )

    if ([string]::IsNullOrEmpty($Companyname)) {
       $Companyname = (Get-NAVCompany -ServerInstance $ServerInstance -Tenant $tenant)[0].CompanyName
    }

    # DynamicsNAV:////RunReport?Report=101
    # $ConnectionString = "DynamicsNAV://$Servername" + ":$Port/$ServerInstance/$MainCompany/?tenant=$tenant"
    $ConnectionString = "DynamicsNAV://$Servername" + ":$Port/$ServerInstance/$MainCompany/RunPage?Page=$pageID"
    Write-Verbose "Starting $ConnectionString ..."
    Start-Process $ConnectionString
}
########################u##########################################################################################
# P R O C E S S
##################################################################################################################
# Close Dev Env
if ($CloseLocalDevEnv -eq $true)
{
    Get-Process -Name '*fin*' | Where-Object {$_.ProductVersion -like '9.0.*'} |
    foreach { 
        Write-Host "$($_.Description), Version $($_.ProductVersion)"
        Stop-Process $_
    } 
}

if ($CloseLocalWinClient -eq $true)
{
   Get-Process -Name '*Microsoft.Dynamics.Nav.Client*' | Where-Object {$_.ProductVersion -like '9.0.*'} |
    foreach { 
        Write-Host "$($_.Description), Version $($_.ProductVersion)"
        Stop-Process $_        
    } 
}

# Restart the NST
if ($RestartNST -eq $true)
{
    write-Host -ForegroundColor DarkGray "Restart Servicetier $($NAVServiceTier)..."
    Set-NAVServerInstance $NAVServiceTier -Restart
    write-Host -ForegroundColor DarkGray ">Done"
}


# Copy To Add In Folder
write-Host -ForegroundColor DarkGray "Copy Add-In DLL $($AddInDLL)..."
Copy-Item -Path $AddInDLL -Destination $ToWinClientAddFolder -Force
write-Host -ForegroundColor DarkGray ">Done"


# Zip the Manifest 
write-Host -ForegroundColor DarkGray "Zip Manifest $($AddInRessourceZipFolder)..."
## With 7Zip
if (-not (test-path "$env:ProgramFiles\7-Zip\7z.exe")) {throw "$env:ProgramFiles\7-Zip\7z.exe needed"} 
set-alias 7Zip "$env:ProgramFiles\7-Zip\7z.exe" 
# 7Zip a -tzip "$AddInRessourceZipFolder" "$AddInRessourceFolder"
$AddInRessourceFolderFiles = Get-ChildItem -Path $AddInRessourceFolder -Exclude $AddInRessourceZipFolder
foreach ($file in $AddInRessourceFolderFiles) { 
    $name = $file.name 
    $directory = $file.DirectoryName 
    $zipfile = $file.BaseName+".7z" 
    7Zip a -tzip "$AddInRessourceZipFolder" "$AddInRessourceFolder\$name"      
    #Write-Host "$AddInRessourceFolder\$name"      
} 
  
# With Windows Zip
# $tmpAddInRessourceZipFolder = ZipFolder -Folder $AddInRessourceFolder 
# Copy-Item -Path $tmpAddInRessourceZipFolder -Destination $AddInRessourceZipFolder
# $AddInRessourceZipFolder = $tmpAddInRessourceZipFolder

write-Host -ForegroundColor DarkGray ">Done"


# Update in Database
write-Host -ForegroundColor DarkGray "Entferne Add-In $($AddInName)..."
Remove-NAVAddIn -AddInName $AddInName `
	-PublicKeyToken $Token `
	-ServerInstance $NAVServiceTier `
    -Force
write-Host -ForegroundColor DarkGray ">Done"

write-Host -ForegroundColor DarkGray "Füge Add-In $($AddInName) hinzu..."
New-NAVAddIn `
	-AddInName $AddInName `
	-PublicKeyToken $Token `
	-ServerInstance $NAVServiceTier `
	-Category JavaScriptControlAddIn `
	-ResourceFile $AddInRessourceZipFolder `
    -Description $AddInName `
	-ErrorAction Stop     
write-Host -ForegroundColor DarkGray ">Done"

if ($StartLocalDevEnv -eq $true)
{
    Start-NAVIdeClient -ServerName $SQLServer -Database $NAVDatabase
}

if ($StartLocalWinClient -eq $true)
{
    Start-NAVWindowsClientPage -ServerName $ServerName -Port 9246 -ServerInstance $NAVServiceTier -Companyname "CRONUS AG" -pageID $RunPageAtStart 

    # Sicherheitsabfrage abfangen
    Do {
        $TimeOutEllapsed = $TimeOutEllapsed + 1;
    
        $status = Get-Process -ErrorAction SilentlyContinue| Where-Object {$_.MainWindowTitle -like "Microsoft Dynamics NAV-Sicherheitshinweis"}
    
        if (!($status)) { 
            Write-Host 'Waiting for process to start' ; 
            Start-Sleep -Seconds 1 ;
        } Else { 
            Write-Host 'Process has started' ; 
            $started = $true             
        }

    }Until ( $started -or ($TimeOutEllapsed -eq 10)) 

    if ($started){
        $wshell = New-Object -ComObject wscript.shell;
        $wshell.AppActivate('title of the application window')
        #Sleep 1
        
        $wshell.SendKeys('~')
    }
}