<# This form was created using POSHGUI.com  a free online gui designer for PowerShell
.NAME
    Test_190120
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '400,400'
$Form.text                       = "Form"
$Form.TopMost                    = $false

$TextBox1                        = New-Object system.Windows.Forms.TextBox
$TextBox1.multiline              = $false
$TextBox1.width                  = 100
$TextBox1.height                 = 20
$TextBox1.location               = New-Object System.Drawing.Point(117,67)
$TextBox1.Font                   = 'Microsoft Sans Serif,10'

$Form.controls.AddRange(@($TextBox1))




#Write your logic code here

[void]$Form.ShowDialog()