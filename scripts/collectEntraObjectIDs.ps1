# Load the helper function for getting the Object ID
. "$PSScriptRoot/helpFunctions/Get-DeviceObjectId.ps1"

# Define file paths
$csvInputPath = "$PSScriptRoot/../ExternalDevices.csv"
$outputFilePath = "$PSScriptRoot/../files/EntraObjectIDs.csv"

# Ensure the Microsoft Graph Beta module is loaded
Import-Module Microsoft.Graph.Beta.Identity.DirectoryManagement

# Check if the input CSV file exists
if (-not (Test-Path $csvInputPath)) {
    Write-Host "Error: Input CSV file not found at $csvInputPath." -ForegroundColor Red
    LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "Input CSV file not found at $csvInputPath."
    exit 1
}

# Read the device names from the CSV
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

# Get total device count for loading bar
$totalDevices = $deviceNames.Count
$currentDevice = 0

# Ensure there are devices to process
if ($totalDevices -eq 0) {
    Write-Host "No devices found to process." -ForegroundColor Yellow
    exit 0
}

# Loop through each device name and query Microsoft Graph for Object ID
Write-Host "Collecting EntraObject IDs..."
foreach ($deviceName in $deviceNames) {
    $currentDevice++
    
    # Update loading bar for each device
    $progress = ($currentDevice / $totalDevices) * 100
    Write-Progress -Activity "Collecting EntraObject IDs" -Status "$([math]::Round($progress, 2))% Complete" -PercentComplete $progress

    # Query Microsoft Graph for Object ID
    $objectId = Get-DeviceObjectId -DeviceName $deviceName

    if ($objectId) {
        $results += [pscustomobject]@{
            Name          = $deviceName
            EntraObjectID = $objectId
        }
        LogSuccess -TaskName "collectEntraObjectIDs" -Message "Found ObjectID for $deviceName : $objectId"
    } else {
        LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "No ObjectID found for $deviceName."
    }
}

# Finish loading bar
Write-Progress -Activity "Collecting EntraObject IDs" -Completed

Write-Host "Finished collecting EntraObject IDs." -ForegroundColor Green


# Save the results to a new CSV file in the 'files' folder
try {
    if ($results.Count -gt 0) {
        $results | Export-Csv -Path $outputFilePath -NoTypeInformation
        Write-Host "Successfully saved Object IDs to $outputFilePath" -ForegroundColor Green
        LogSuccess -TaskName "collectEntraObjectIDs" -Message "Successfully saved Object IDs to $outputFilePath"
    } else {
        Write-Host "No Object IDs found to save." -ForegroundColor Yellow
        LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "No Object IDs found to save."
    }
} catch {
    Write-Host "Error saving Object IDs to CSV: $_" -ForegroundColor Red
    LogError -TaskName "collectEntraObjectIDs" -ErrorMessage "Failed to save Object IDs: $_"
    exit 1
}
