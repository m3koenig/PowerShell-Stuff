#Requires -PSEdition Desktop 
Set-StrictMode -Version 2.0

Write-Host -ForegroundColor Yellow "========================================="
Write-Host -ForegroundColor Yellow "                MKO Helper"
Write-Host -ForegroundColor Yellow "========================================="


$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
$isAdministrator = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
try {
    $myUsername = $currentPrincipal.Identity.Name
} catch {
    $myUsername = (whoami)
}

$SrcPath = "src"

$FunctionName = "Remove-MKODuplicatedOldModules"
$FunctionPath = Join-Path $PSScriptRoot $SrcPath
$FunctionPath = Join-Path $FunctionPath "$($FunctionName).ps1"
Write-Host -ForegroundColor Yellow "Import of Function $($FunctionName)"
. $FunctionPath

$FunctionName = "Move-MKOContainerInksToFolder"
$FunctionPath = Join-Path $PSScriptRoot $SrcPath
$FunctionPath = Join-Path $FunctionPath "$($FunctionName).ps1"
Write-Host -ForegroundColor Yellow "Import of Function $($FunctionName)"
. $FunctionPath

$FunctionName = "New-MKOBCContainer"
$FunctionPath = Join-Path $PSScriptRoot $SrcPath
$FunctionPath = Join-Path $FunctionPath "$($FunctionName).ps1"
Write-Host -ForegroundColor Yellow "Import of Function $($FunctionName)"
. $FunctionPath

$FunctionName = "Get-MKOBCImage"
$FunctionPath = Join-Path $PSScriptRoot $SrcPath
$FunctionPath = Join-Path $FunctionPath "$($FunctionName).ps1"
Write-Host -ForegroundColor Yellow "Import of Function $($FunctionName)"
. $FunctionPath

Export-ModuleMember -Function *


Write-Host -ForegroundColor Yellow ""
Write-Host -ForegroundColor Yellow "========================================="