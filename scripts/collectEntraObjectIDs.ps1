# This script reads device names from an external CSV file, queries Microsoft Graph to retrieve their EntraObject IDs, and saves the results to a new CSV file.

# Load helper function for fetching Object IDs
. "$PSScriptRoot/helpFunctions/Get-DeviceObjectId.ps1"

# Define file paths
$csvInputPath = "$PSScriptRoot/../ExternalDevices.csv"
$outputFilePath = "$PSScriptRoot/../files/EntraObjectIDs.csv"
$devicesWithoutIdFile = "$PSScriptRoot/../files/DevicesWithoutEntraID.csv"

# Ensure Microsoft Graph Beta module is imported
Import-Module Microsoft.Graph.Beta.Identity.DirectoryManagement

# Verify the input CSV exists
if (-not (Test-Path $csvInputPath)) {
    Write-Host "Error: Input CSV file not found at $csvInputPath." -ForegroundColor Red
    LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "Input CSV file not found."
    exit 1
}

# Read device names from the CSV
try {
    $devices = Import-Csv -Path $csvInputPath
    $deviceNames = $devices | Select-Object -ExpandProperty Name
} catch {
    Write-Host "Error reading the input CSV file." -ForegroundColor Red
    LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "Failed to read input CSV: $_"
    exit 1
}

# Prepare for output
$results = @()
$devicesWithoutId = @()

# Check if there are devices to process
$totalDevices = $deviceNames.Count
$currentDevice = 0
if ($totalDevices -eq 0) {
    Write-Host "No devices found to process." -ForegroundColor Yellow
    exit 0
}

# Process each device and query Microsoft Graph for Object ID
Write-Host "Collecting EntraObject IDs..."
foreach ($deviceName in $deviceNames) {

    # Query Microsoft Graph for Object ID
    $objectId = Get-DeviceObjectId -DeviceName $deviceName

    if ($objectId) {
        $results += [pscustomobject]@{
            Name          = $deviceName
            EntraObjectID = $objectId
        }
        LogSuccess -TaskName "collectEntraObjectIDs" -Message "Found ObjectID for $deviceName : $objectId"
    } else {
        # Track devices without Object ID and log them
        $devicesWithoutId += [pscustomobject]@{ Name = $deviceName }
        LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "No ObjectID found for $deviceName."
    }

    # Increment after processing and update progress bar
    $currentDevice++
    $progress = ($currentDevice / $totalDevices) * 100
    $progressText = "$([math]::Round($progress, 2))% Complete".PadRight(30)  # Ensure the progress bar status text takes up enough space
    Write-Progress -Activity "Collecting EntraObject IDs" -Status $progressText -PercentComplete $progress
}

# Complete progress bar
Write-Progress -Activity "Collecting EntraObject IDs" -Completed

Write-Host "Finished collecting EntraObject IDs." -ForegroundColor Green

# Save the results to a CSV
try {
    if ($results.Count -gt 0) {
        $results | Export-Csv -Path $outputFilePath -NoTypeInformation
        Write-Host "Successfully saved Object IDs to $outputFilePath" -ForegroundColor Green
        LogSuccess -TaskName "collectEntraObjectIDs" -Message "Successfully saved Object IDs."
    } else {
        Write-Host "No Object IDs found to save." -ForegroundColor Yellow
        LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "No Object IDs found to save."
    }
} catch {
    Write-Host "Error saving Object IDs to CSV: $_" -ForegroundColor Red
    LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "Failed to save Object IDs: $_"
    exit 1
}

# Save devices without EntraObjectID to a separate file
if ($devicesWithoutId.Count -gt 0) {
    $devicesWithoutId | Export-Csv -Path $devicesWithoutIdFile -NoTypeInformation
    Write-Host "Devices without EntraObjectIDs were saved to: $devicesWithoutIdFile" -ForegroundColor Yellow
}
