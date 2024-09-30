function ProcessCsvFile {
    param (
        [string]$csvPath
    )

    # Verify the input CSV exists
    if (-not (Test-Path $csvPath)) {
        [System.Windows.Forms.MessageBox]::Show("CSV file not found at $csvPath.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return $null
    }

    # Read device names from the CSV
    try {
        $devices = Import-Csv -Path $csvPath
        $deviceNames = $devices | Select-Object -ExpandProperty Name
        return $deviceNames  # Return the device names
    } catch {
        [System.Windows.Forms.MessageBox]::Show("Error reading the CSV file.", "Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return $null
    }
}
