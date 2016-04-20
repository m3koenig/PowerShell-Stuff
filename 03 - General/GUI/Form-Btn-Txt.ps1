[void] [System.Reflection.Assembly]::LoadWithPartialName(„System.Drawing“)
[void] [System.Reflection.Assembly]::LoadWithPartialName(„System.Windows.Forms“)

$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = „Dateneingabe“
$objForm.Size = New-Object System.Drawing.Size(400,300)
$objForm.StartPosition = „CenterScreen“
$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq „Enter“) { $objForm.DialogResult=“OK“;$objForm.Close()} })
$objForm.Add_KeyDown({if ($_.KeyCode -eq „Escape“) { $objForm.DialogResult=“Cancel“;$objForm.Close()} })

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,120)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = „OK“
$OKButton.DialogResult = „OK“
$OKButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,120)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = „Cancel“
$CancelButton.DialogResult = „Cancel“
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = „Bitte geben Sie etwas ein:“
$objForm.Controls.Add($objLabel)
$objTextBox = New-Object System.Windows.Forms.TextBox 
$objTextBox.Location = New-Object System.Drawing.Size(10,40) 
$objTextBox.Size = New-Object System.Drawing.Size(260,20)
$objTextBox.Text = „Vorgabe“
$objForm.Controls.Add($objTextBox)

[void] $objForm.ShowDialog()

If ($objForm.DialogResult -like „OK“) {$objTextBox.Text} else {„Abbruch geklickt“}