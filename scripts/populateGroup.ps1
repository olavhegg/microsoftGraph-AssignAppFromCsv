# Import the Microsoft Graph Beta module for Groups
Import-Module Microsoft.Graph.Beta.Groups

# Load helper functions
. "$PSScriptRoot/helpFunctions/Add-DeviceToGroup.ps1"
. "$PSScriptRoot/helpFunctions/Get-IntuneGroupMembers.ps1"
. "$PSScriptRoot/handlers/LogHandler.ps1"

# Default path for device list CSV
$devicesCsvPath = "$PSScriptRoot/../files/EntraObjectIDs.csv"
$devicesWithoutIdCsvPath = "$PSScriptRoot/../files/DevicesWithoutEntraObjectIds.csv"

# Check if the devices CSV file exists
if (-not (Test-Path $devicesCsvPath)) {
    Write-Host "Error: Devices CSV file not found at $devicesCsvPath." -ForegroundColor Red
    LogError -TaskName "populateGroup" -ErrorMessage "Devices CSV file not found at $devicesCsvPath."
    exit 1
}

# Import the devices from the CSV file
try {
    $devices = Import-Csv -Path $devicesCsvPath
} catch {
    Write-Host "Error reading the devices CSV file: $_" -ForegroundColor Red
    LogError -TaskName "populateGroup" -ErrorMessage "Failed to read devices CSV: $_"
    exit 1
}

# Create a list to hold devices without EntraObjectID
$devicesWithoutEntraObjectId = @()

# Get the total number of devices for the loading bar
$totalDevices = $devices.Count
$currentDevice = 0

# Display loading bar
Write-Host "Populating group with devices..."

# Loop through each device
foreach ($device in $devices) {
    $currentDevice++
    
    # Update the progress bar for every device
    $progress = ($currentDevice / $totalDevices) * 100
    Write-Progress -Activity "Populating group" -Status "$([math]::Round($progress, 2))% Complete" -PercentComplete $progress

    # Skip devices that do not have an EntraObjectID
    if (-not $device.EntraObjectID) {
        $devicesWithoutEntraObjectId += $device.Name
        continue
    }

    # Add device to group
    Add-DeviceToGroup -groupId $Global:groupId -deviceId $device.EntraObjectID
}

# Save devices without EntraObjectID to a CSV
if ($devicesWithoutEntraObjectId.Count -gt 0) {
    $devicesWithoutEntraObjectId | Export-Csv -Path $devicesWithoutIdCsvPath -NoTypeInformation
}

# Finish loading bar
Write-Progress -Activity "Populating group" -Completed

# Inform the user about skipped devices
if ($devicesWithoutEntraObjectId.Count -gt 0) {
    Write-Host "`nDevices without EntraObjectIDs were skipped. A list of these devices has been saved to: $devicesWithoutIdCsvPath" -ForegroundColor Yellow
}

Write-Host "Finished populating the group with devices." -ForegroundColor Green
LogSuccess -TaskName "populateGroup" -Message "Successfully populated group $Global:groupId with devices."
exit 0
