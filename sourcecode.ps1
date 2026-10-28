Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# --- AUTO ELEVATE TO ADMINISTRATOR ---
$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (-not $isAdmin) {
    $arguments = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`""
    Start-Process powershell.exe -ArgumentList $arguments -Verb RunAs
    Exit
}

# --- AUTO DETECT STARTUP EXECUTION CONTEXT ---
$scriptPath = $MyInvocation.MyCommand.Path
$startupPath = [System.IO.Path]::Combine([Environment]::GetFolderPath('Startup'))

if ($scriptPath -and (Split-Path $scriptPath -Parent) -eq $startupPath) {
    [System.IO.Directory]::SetCurrentDirectory($startupPath)
}

# --- DESIGN UTILITIES & PROPERTIES ---
$fontTitle = New-Object System.Drawing.Font("Segoe UI Semibold", 13)
$fontLabel = New-Object System.Drawing.Font("Segoe UI", 9.5)
$fontInput = New-Object System.Drawing.Font("Segoe UI", 11)
$fontBtn   = New-Object System.Drawing.Font("Segoe UI Semibold", 9.5)

$colorBg        = [System.Drawing.Color]::FromArgb(249, 249, 251) 
$colorTextMain  = [System.Drawing.Color]::FromArgb(33, 37, 41)
$colorTextMuted = [System.Drawing.Color]::FromArgb(108, 117, 125)
$colorPrimary   = [System.Drawing.Color]::FromArgb(0, 102, 204)   
$colorLightBtn  = [System.Drawing.Color]::FromArgb(240, 242, 245)

# --- CONTAINER WINDOW SETUP ---
$form = New-Object System.Windows.Forms.Form
$form.Text = "Account Security Manager"
$form.Size = New-Object System.Drawing.Size(420, 340)
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = "FixedDialog"
$form.MaximizeBox = $false
$form.MinimizeBox = $false
$form.TopMost = $true
$form.BackColor = $colorBg

# --- HEADER HEADLINE GRAPHICS ---
$labelUser = New-Object System.Windows.Forms.Label
$labelUser.Text = "Change Password"
$labelUser.Location = New-Object System.Drawing.Point(30, 24)
$labelUser.Size = New-Object System.Drawing.Size(350, 28)
$labelUser.Font = $fontTitle
$labelUser.ForeColor = $colorTextMain
$form.Controls.Add($labelUser)

$labelSub = New-Object System.Windows.Forms.Label
$labelSub.Text = "Updating account credentials for: $env:USERNAME"
$labelSub.Location = New-Object System.Drawing.Point(30, 52)
$labelSub.Size = New-Object System.Drawing.Size(350, 20)
$labelSub.Font = $fontLabel
$labelSub.ForeColor = $colorTextMuted
$form.Controls.Add($labelSub)

# --- GLOBAL ACCESSIBILITY CHECKBOX ---
$checkboxShow = New-Object System.Windows.Forms.CheckBox
$checkboxShow.Text = "Show typed characters"
$checkboxShow.Location = New-Object System.Drawing.Point(32, 172)
$checkboxShow.Size = New-Object System.Drawing.Size(200, 22)
$checkboxShow.Font = $fontLabel
$checkboxShow.ForeColor = $colorTextMuted
$checkboxShow.FlatStyle = "Flat"
$form.Controls.Add($checkboxShow)


# --- PANEL 1 (NEW PASSWORD GENERATION) ---
$panel1 = New-Object System.Windows.Forms.Panel
$panel1.Location = New-Object System.Drawing.Point(0, 85)
$panel1.Size = New-Object System.Drawing.Size(420, 210)
$form.Controls.Add($panel1)

$labelNew = New-Object System.Windows.Forms.Label
$labelNew.Text = "Enter your new password:"
$labelNew.Location = New-Object System.Drawing.Point(30, 10)
$labelNew.Size = New-Object System.Drawing.Size(350, 20)
$labelNew.Font = $fontLabel
$labelNew.ForeColor = $colorTextMain
$panel1.Controls.Add($labelNew)

$textboxNew = New-Object System.Windows.Forms.TextBox
$textboxNew.Location = New-Object System.Drawing.Point(30, 34)
$textboxNew.Size = New-Object System.Drawing.Size(344, 28)
$textboxNew.Font = $fontInput
$textboxNew.UseSystemPasswordChar = $true
$panel1.Controls.Add($textboxNew)

$btnCancel = New-Object System.Windows.Forms.Button
$btnCancel.Text = "Cancel"
$btnCancel.Location = New-Object System.Drawing.Point(30, 120)
$btnCancel.Size = New-Object System.Drawing.Size(164, 38)
$btnCancel.Font = $fontBtn
$btnCancel.BackColor = $colorLightBtn
$btnCancel.ForeColor = $colorTextMain
$btnCancel.FlatStyle = "Flat"
$btnCancel.FlatAppearance.BorderSize = 0
$panel1.Controls.Add($btnCancel)

$btnCancel.Add_Click({ $form.Close() })

$btnNext = New-Object System.Windows.Forms.Button
$btnNext.Text = "Next Step"
$btnNext.Location = New-Object System.Drawing.Point(210, 120)
$btnNext.Size = New-Object System.Drawing.Size(164, 38)
$btnNext.Font = $fontBtn
$btnNext.BackColor = $colorPrimary
$btnNext.ForeColor = [System.Drawing.Color]::White
$btnNext.FlatStyle = "Flat"
$btnNext.FlatAppearance.BorderSize = 0
$panel1.Controls.Add($btnNext)

$btnNext.Add_Click({
    if ([string]::IsNullOrWhiteSpace($textboxNew.Text)) {
        [System.Windows.Forms.MessageBox]::Show("Please type your new password.", "Input Empty", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
        $textboxNew.Focus()
        return
    }
    $panel1.Visible = $false
    $panel2.Visible = $true
    $textboxConfirm.Focus()
})


# --- PANEL 2 (CONFIRMATION MATRIX) ---
$panel2 = New-Object System.Windows.Forms.Panel
$panel2.Location = New-Object System.Drawing.Point(0, 85)
$panel2.Size = New-Object System.Drawing.Size(420, 210)
$panel2.Visible = $false
$form.Controls.Add($panel2)

$labelConfirm = New-Object System.Windows.Forms.Label
$labelConfirm.Text = "Confirm your new password:"
$labelConfirm.Location = New-Object System.Drawing.Point(30, 10)
$labelConfirm.Size = New-Object System.Drawing.Size(350, 20)
$labelConfirm.Font = $fontLabel
$labelConfirm.ForeColor = $colorTextMain
$panel2.Controls.Add($labelConfirm)

$textboxConfirm = New-Object System.Windows.Forms.TextBox
$textboxConfirm.Location = New-Object System.Drawing.Point(30, 34)
$textboxConfirm.Size = New-Object System.Drawing.Size(344, 28)
$textboxConfirm.Font = $fontInput
$textboxConfirm.UseSystemPasswordChar = $true
$panel2.Controls.Add($textboxConfirm)

$btnBack = New-Object System.Windows.Forms.Button
$btnBack.Text = "Go Back"
$btnBack.Location = New-Object System.Drawing.Point(30, 120)
$btnBack.Size = New-Object System.Drawing.Size(164, 38)
$btnBack.Font = $fontBtn
$btnBack.BackColor = $colorLightBtn
$btnBack.ForeColor = $colorTextMain
$btnBack.FlatStyle = "Flat"
$btnBack.FlatAppearance.BorderSize = 0
$panel2.Controls.Add($btnBack)

$btnBack.Add_Click({
    $panel2.Visible = $false
    $panel1.Visible = $true
    $textboxNew.Focus()
})

$btnApply = New-Object System.Windows.Forms.Button
$btnApply.Text = "Update Password"
$btnApply.Location = New-Object System.Drawing.Point(210, 120)
$btnApply.Size = New-Object System.Drawing.Size(164, 38)
$btnApply.Font = $fontBtn
$btnApply.BackColor = $colorPrimary
$btnApply.ForeColor = [System.Drawing.Color]::White
$btnApply.FlatStyle = "Flat"
$btnApply.FlatAppearance.BorderSize = 0
$panel2.Controls.Add($btnApply)

$btnApply.Add_Click({
    try {
        $pass = $textboxNew.Text
        $confirmPass = $textboxConfirm.Text
        
        if ($pass -ne $confirmPass) {
            [System.Windows.Forms.MessageBox]::Show("The confirmation password doesn't match your original input. Please try again.", "Mismatch Detected", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
            $textboxConfirm.Clear()
            $textboxConfirm.Focus()
            return
        }
        
        net user $env:USERNAME "$pass" 2>&1 | Out-String -OutVariable netOutput
        
        if ($LASTEXITCODE -ne 0) {
            throw $netOutput
        }
        
        [System.Windows.Forms.MessageBox]::Show("Password updated successfully!", "Success Management", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        $form.Close()
    }
    catch {
        [System.Windows.Forms.MessageBox]::Show("Execution processing error.`n`nDetails: $_", "Error Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
    }
})


# --- RENDER HOOK SIGNALS & DIALOG RUNTIME ---
$checkboxShow.Add_CheckedChanged({
    $reveal = $checkboxShow.Checked
    $textboxNew.UseSystemPasswordChar = !$reveal
    $textboxConfirm.UseSystemPasswordChar = !$reveal
    $textboxNew.Invalidate()
    $textboxConfirm.Invalidate()
})

$form.Add_Shown({ $textboxNew.Focus() })
$form.ShowDialog() | Out-Null
