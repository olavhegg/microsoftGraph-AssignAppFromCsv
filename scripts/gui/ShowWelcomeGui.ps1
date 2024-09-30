. "$PSScriptRoot/ShowCollectEntraIDsGui.ps1"
. "$PSScriptRoot/ClearForm.ps1"

function ShowWelcomeScreen {
    param (
        [ref]$form
    )

    # Title label for the application
    $titleLabel = New-Object System.Windows.Forms.Label
    $titleLabel.Text = "Intune App Assignment Automation Tool"
    $titleLabel.Font = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold)
    $titleLabel.AutoSize = $true
    $form.Value.Controls.Add($titleLabel)

    # Styled Connect to Azure button
    $btnConnect = New-Object System.Windows.Forms.Button
    $btnConnect.Text = "Connect to Azure Tenant"
    $btnConnect.Font = New-Object System.Drawing.Font("Arial", 14, [System.Drawing.FontStyle]::Regular)
    $btnConnect.BackColor = [System.Drawing.Color]::DodgerBlue
    $btnConnect.ForeColor = [System.Drawing.Color]::White
    $btnConnect.FlatStyle = 'Flat'
    $btnConnect.FlatAppearance.BorderSize = 0
    $btnConnect.Size = New-Object System.Drawing.Size(220, 60)
    $form.Value.Controls.Add($btnConnect)

    # Center the title label and button based on the form size
    $formWidth = $form.Value.ClientSize.Width
    $titleLabel.Location = New-Object System.Drawing.Point(([math]::Floor(($formWidth - $titleLabel.Width) / 2)), 40)
    $btnConnect.Location = New-Object System.Drawing.Point(([math]::Floor(($formWidth - $btnConnect.Width) / 2)), 180)

    # Event handler for the Connect button
    $btnConnect.Add_Click({
        # Direct connection process in the same thread
        $connection = ConnectToGraph -Scopes @(
            "DeviceManagementManagedDevices.ReadWrite.All",
            "Group.ReadWrite.All",
            "GroupMember.ReadWrite.All",
            "Directory.Read.All",
            "Device.ReadWrite.All",
            "Directory.AccessAsUser.All"
        )

        # If connection is successful, clear the form and proceed to the next screen
        if ($connection) {
            ClearForm -form ([ref]$form)  # Clear form to show the next screen
            ShowCollectEntraIDsScreen -form ([ref]$form)  # Proceed to next task
        } else {
            [System.Windows.Forms.MessageBox]::Show("Failed to connect to Azure Tenant.", "Connection Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
    })
}
