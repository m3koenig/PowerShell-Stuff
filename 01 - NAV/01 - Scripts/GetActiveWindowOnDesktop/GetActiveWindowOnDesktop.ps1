# Source; http://techibee.com/powershell/get-active-window-on-desktop-using-powershell/2178

[CmdletBinding()]            
Param(            
)            
Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class UserWindows {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@            
try {            
#$ActiveHandle = [Windows]::GetForegroundWindow()   
$ActiveHandle = [UserWindows]::GetForegroundWindow()         
$Process = Get-Process | ? {$_.MainWindowHandle -eq $activeHandle}            
$Process | Select ProcessName, @{Name="AppTitle";Expression= {($_.MainWindowTitle)}}            
} catch {            
 Write-Error "Failed to get active Window details. More Info: $_"            
}