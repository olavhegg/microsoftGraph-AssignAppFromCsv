# This script reads devices from a CSV file, adds them to a specified group, and logs any devices without EntraObject IDs.

# Import Microsoft Graph module for group management
Import-Module Microsoft.Graph.Beta.Groups

# Load helper functions
. "$PSScriptRoot/helpFunctions/Add-DeviceToGroup.ps1"
. "$PSScriptRoot/helpFunctions/Get-IntuneGroupMembers.ps1"
. "$PSScriptRoot/handlers/LogHandler.ps1"

# Define file paths
$devicesCsvPath = "$PSScriptRoot/../files/EntraObjectIDs.csv"
$devicesWithoutIdCsvPath = "$PSScriptRoot/../files/DevicesWithoutEntraObjectIds.csv"

# Check if the devices CSV file exists
if (-not (Test-Path $devicesCsvPath)) {
    Write-Host "Error: Devices CSV file not found at $devicesCsvPath." -ForegroundColor Red
    LogError -TaskName "populateGroup" -ErrorMessage "Devices CSV file not found."
    exit 1
}

# Import devices from CSV
try {
    $devices = Import-Csv -Path $devicesCsvPath
} catch {
    Write-Host "Error reading the devices CSV file: $_" -ForegroundColor Red
    LogError -TaskName "populateGroup" -ErrorMessage "Failed to read devices CSV: $_"
    exit 1
}

# Create list for devices without EntraObjectID
$devicesWithoutEntraObjectId = @()

# Get total device count for progress tracking
$totalDevices = $devices.Count
$currentDevice = 0

Write-Host "Populating group with devices..."

# Loop through each device and add to the group
foreach ($device in $devices) {
    $currentDevice++
    $progress = ($currentDevice / $totalDevices) * 100
    Write-Progress -Activity "Populating group" -Status "$([math]::Round($progress, 2))% Complete" -PercentComplete $progress

    # Skip devices without EntraObjectID
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

# Finish progress bar
Write-Progress -Activity "Populating group" -Completed

# Inform about skipped devices
if ($devicesWithoutEntraObjectId.Count -gt 0) {
    Write-Host "`nDevices without EntraObjectIDs were skipped. A list of these devices has been saved to: $devicesWithoutIdCsvPath" -ForegroundColor Yellow
}

Write-Host "Finished populating the group." -ForegroundColor Green
LogSuccess -TaskName "populateGroup" -Message "Group $Global:groupId populated with devices."
exit 0
