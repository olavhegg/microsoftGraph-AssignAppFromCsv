# ShowPoweredByLabel.ps1: Function to show "Powered by" label with "Team SQUAT" styled differently, aligned to the right
function ShowPoweredByLabel {
    param (
        [ref]$form
    )

    # Create label for the "Powered by" message
    $poweredByLabel = New-Object System.Windows.Forms.Label
    $poweredByLabel.AutoSize = $true
    $poweredByLabel.Font = New-Object System.Drawing.Font("Verdana", 12, [System.Drawing.FontStyle]::Italic)
    $poweredByLabel.Text = "Powered by "
    $poweredByLabel.Tag = "footer"

    # Create a label for "Team SQUAT"
    $teamSquatLabel = New-Object System.Windows.Forms.Label
    $teamSquatLabel.Text = "Team SQUAT"
    $teamSquatLabel.Font = New-Object System.Drawing.Font("Verdana", 12, [System.Drawing.FontStyle]::Italic)
    $teamSquatLabel.ForeColor = [System.Drawing.Color]::RoyalBlue
    $teamSquatLabel.AutoSize = $true
    $teamSquatLabel.Tag = "footer"

    # Add both labels to the form
    $form.Value.Controls.Add($poweredByLabel)
    $form.Value.Controls.Add($teamSquatLabel)

    # Adjust the positions based on form size
    $formWidth = $form.Value.ClientSize.Width
    $formHeight = $form.Value.ClientSize.Height

    # Position the "Powered by" label on the right side, with "Team SQUAT" after it
    $poweredByLabel.Location = New-Object System.Drawing.Point(($formWidth - 260), ($formHeight - 30))
    $teamSquatLabel.Location = New-Object System.Drawing.Point(($poweredByLabel.Location.X + $poweredByLabel.Width), ($formHeight - 30))
}
