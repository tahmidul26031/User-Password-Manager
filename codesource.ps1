Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

$form = New-Object System.Windows.Forms.Form
$form.Text = "Change Password"
$form.Size = New-Object System.Drawing.Size(420, 230)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true
$form.BackColor = [System.Drawing.Color]::WhiteSmoke

$labelUser = New-Object System.Windows.Forms.Label
$labelUser.Text = "Current User: $env:USERNAME"
$labelUser.Location = New-Object System.Drawing.Point(30, 20)
$labelUser.Size = New-Object System.Drawing.Size(350, 25)
$labelUser.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$form.Controls.Add($labelUser)

$labelInfo = New-Object System.Windows.Forms.Label
$labelInfo.Text = "Type new password below"
$labelInfo.Location = New-Object System.Drawing.Point(30, 50)
$labelInfo.Size = New-Object System.Drawing.Size(350, 40)
$labelInfo.Font = New-Object System.Drawing.Font("Segoe UI", 9)
$form.Controls.Add($labelInfo)

$textbox = New-Object System.Windows.Forms.TextBox
$textbox.Location = New-Object System.Drawing.Point(30, 100)
$textbox.Size = New-Object System.Drawing.Size(340, 28)
$textbox.Font = New-Object System.Drawing.Font("Segoe UI", 11)
$form.Controls.Add($textbox)

$button = New-Object System.Windows.Forms.Button
$button.Text = "Apply"
$button.Location = New-Object System.Drawing.Point(140, 145)
$button.Size = New-Object System.Drawing.Size(120, 35)
$button.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$button.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 215)
$button.ForeColor = [System.Drawing.Color]::White
$button.FlatStyle = "Flat"
$form.Controls.Add($button)

$button.Add_Click({
    try {
        $pass = $textbox.Text
        if ([string]::IsNullOrWhiteSpace($pass)) {
            net user $env:USERNAME "" | Out-Null
            [System.Windows.Forms.MessageBox]::Show("Please type your new password", "Error", "OK", "Information")
        } else {
            net user $env:USERNAME "$pass" | Out-Null
            [System.Windows.Forms.MessageBox]::Show("Password changed successfully!", "Done", "OK", "Information")
        }
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error: $_", "Failed", "OK", "Error")
    }
    $form.Close()
})

$form.Add_Shown({ $textbox.Focus() })
$form.ShowDialog() | Out-Null
