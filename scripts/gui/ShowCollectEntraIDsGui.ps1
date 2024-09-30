# Import necessary functions and scripts
. "$PSScriptRoot/StartEntraIDCollection.ps1"
. "$PSScriptRoot/ProcessCsvFile.ps1"
. "$PSScriptRoot/ShowCreateGroupGui.ps1"  # Import the next screen function
. "$PSScriptRoot/ClearForm.ps1"

# ShowCollectEntraIDsGui.ps1: Handles the GUI for uploading a CSV and collecting EntraObject IDs
function ShowCollectEntraIDsScreen {
    param (
        [ref]$form
    )

    # Header Label for Upload CSV
    $headerLabel = New-Object System.Windows.Forms.Label
    $headerLabel.Text = "Upload CSV"
    $headerLabel.Font = New-Object System.Drawing.Font("Arial", 22, [System.Drawing.FontStyle]::Bold)
    $headerLabel.AutoSize = $true
    $form.Value.Controls.Add($headerLabel)

    # Adjust window dimensions to center the header and button
    $formWidth = $form.Value.ClientSize.Width
    $formHeight = $form.Value.ClientSize.Height

    # Center the header label
    $headerLabel.Location = New-Object System.Drawing.Point(([math]::Floor(($formWidth - $headerLabel.Width) / 2)), 40)

    # Progress bar (starts hidden)
    $progressBar = New-Object System.Windows.Forms.ProgressBar
    $progressBar.Location = New-Object System.Drawing.Point(100, 250)
    $progressBar.Size = New-Object System.Drawing.Size(400, 30)
    $progressBar.Visible = $false
    $form.Value.Controls.Add($progressBar)

    # Add button for manual CSV upload
    $uploadButton = New-Object System.Windows.Forms.Button
    $uploadButton.Text = "Upload CSV"
    $uploadButton.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Regular)
    $uploadButton.Size = New-Object System.Drawing.Size(150, 40)
    $form.Value.Controls.Add($uploadButton)

    # Center the upload button
    $uploadButton.Location = New-Object System.Drawing.Point(([math]::Floor(($formWidth - $uploadButton.Width) / 2)), 180)

    # Add functionality to the button to open file dialog and select a CSV
    $uploadButton.Add_Click({
        $openFileDialog = New-Object System.Windows.Forms.OpenFileDialog
        $openFileDialog.Filter = "CSV files (*.csv)|*.csv"
        if ($openFileDialog.ShowDialog() -eq 'OK') {
            $csvFilePath = $openFileDialog.FileName
            if (-not [string]::IsNullOrEmpty($csvFilePath)) {
                $deviceNames = ProcessCsvFile -csvPath $csvFilePath
                if ($deviceNames) {
                    StartEntraIDCollection -deviceNames $deviceNames -progressBar ([ref]$progressBar) -form ([ref]$form)  # Call function to process devices and show progress
                }
            }
        }
    })
}
