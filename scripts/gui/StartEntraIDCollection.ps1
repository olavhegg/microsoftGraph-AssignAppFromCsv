# StartEntraIDCollection.ps1: Handles the logic for collecting EntraObject IDs and showing the progress bar

function StartEntraIDCollection {
    param (
        [array]$deviceNames,
        [ref]$progressBar,
        [ref]$form
    )

    # Prepare for collecting IDs
    $results = @()
    $devicesWithoutId = @()
    $totalDevices = $deviceNames.Count
    $currentDevice = 0

    # Show the progress bar and initialize it
    $progressBar.Value = 0
    $progressBar.Maximum = $totalDevices
    $progressBar.Visible = $true

    # Collect EntraObject IDs
    foreach ($deviceName in $deviceNames) {
        $objectId = Get-DeviceObjectId -DeviceName $deviceName
        if ($objectId) {
            $results += [pscustomobject]@{
                Name          = $deviceName
                EntraObjectID = $objectId
            }
        } else {
            $devicesWithoutId += [pscustomobject]@{ Name = $deviceName }
        }

        # Update progress bar
        $currentDevice++
        $progressBar.Value = $currentDevice
    }

    # Save the results to CSV
    $outputFilePath = "$PSScriptRoot/../files/EntraObjectIDs.csv"
    if ($results.Count -gt 0) {
        $results | Export-Csv -Path $outputFilePath -NoTypeInformation
        [System.Windows.Forms.MessageBox]::Show("Successfully saved Object IDs to $outputFilePath", "Success", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    } else {
        [System.Windows.Forms.MessageBox]::Show("No Object IDs found to save.", "Warning", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    }

    # Save devices without IDs
    $devicesWithoutIdFile = "$PSScriptRoot/../files/DevicesWithoutEntraID.csv"
    if ($devicesWithoutId.Count -gt 0) {
        $devicesWithoutId | Export-Csv -Path $devicesWithoutIdFile -NoTypeInformation
        [System.Windows.Forms.MessageBox]::Show("Devices without EntraObject IDs were saved to: $devicesWithoutIdFile", "Information", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }

    # Clear form and move to the next screen
    ClearForm -form ([ref]$form)
    ShowCreateGroupScreen -form ([ref]$form)  # Proceed to the next task
}
