# This form was created using POSHGUI.com  a free online gui designer for PowerShell
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

#region begin GUI 
#config size,title,
$Form = New-Object System.Windows.Forms.Form
$Form.ClientSize = '800,500'
$Form.Text = "Titel"
$Form.TopMost = $false

$label1 = New-Object System.Windows.Forms.Label
$label1.Text = "Debloat Options"
$label1.AutoSize = $true
$label1.Width = 25
$label1.Height = 10
$label1.Location = New-Object System.Drawing.Point(9, 8)
$label1.Font = 'Microsoft Sans Serif,12,style=Bold,Underline'

$btn1 = New-Object System.Windows.Forms.Button
$btn1.Text = "Customize Blacklist"
$btn1.Width = 140
$btn1.Height = 40
$btn1.Location = New-Object System.Drawing.Point(9, 32)
$btn1.Font = 'Microsoft Sans Serif,10'

$btn2 = New-Object System.Windows.Forms.Button
$btn2.Text = "Remove All Bloatware"
$btn2.Width = 142
$btn2.Height = 40
$btn2.Location = New-Object System.Drawing.Point(8, 79)
$btn2.Font = 'Microsoft Sans Serif,10'

$btn3 = New-Object System.Windows.Forms.Button
$btn3.Text = "Remove Bloatware With Customized Blacklist"
$btn3.Width = 205
$btn3.Height = 37
$btn3.Location = New-Object System.Drawing.Point(9, 124)
$btn3.Font = 'Microsoft Sans Serif,10'

#Titel
$Label2 = New-Object System.Windows.Forms.Label
$Label2.Text = "Revert Registry Changes"
$Label2.AutoSize = $true
$Label2.Width = 25
$Label2.Height = 10
$Label2.Location = New-Object System.Drawing.Point(254, 7)
$Label2.Font = 'Microsoft Sans Serif,12,style=Bold,Underline'

$btn4 = New-Object System.Windows.Forms.Button
$btn4.Text = "Revert Registry Changes"
$btn4.Width = 113
$btn4.Height = 36
$btn4.Location = New-Object System.Drawing.Point(254, 32)
$btn4.Font = 'Microsoft Sans Serif,10'

$close_btn4 = New-Object System.Windows.Forms.Button
$close_btn4.Text = "Close"
$close_btn4.Width = 152
$close_btn4.Height = 39
$close_btn4.Location = New-Object System.Drawing.Point(9, 385)
$close_btn4.Font = 'Microsoft Sans Serif,10'
#endregion end GUI

#add controls to form
$Form.controls.AddRange(@($label1, $btn1, $btn2, $btn3, $Label1, $btn4, $Label2, $close_btn4))

#region define functions
$btn1.Add_Click({
    Write-Host "clicked btn1"
})

$btn3.Add_Click({ 
    Write-Host "clicked btn2"
})

$btn2.Add_Click({
    Write-Host "clicked btn3"
})

$btn4.Add_Click({
    Write-Host "clicked btn4"
})

$close_btn4.Add_Click( {
    $form.Close()
})
#endregion

[void]$Form.ShowDialog()