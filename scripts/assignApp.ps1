# This script prompts the user for an app ID, retrieves the app name, and allows the user to assign the app to a group (Required, Available, or Uninstall).

# Import Microsoft Graph module for device management
Import-Module Microsoft.Graph.Beta.DeviceManagement

# Load helper functions and log functions
. "$PSScriptRoot/helpFunctions/Get-AppName.ps1"
. "$PSScriptRoot/handlers/LogHandler.ps1"

# Prompt the user to input the App ID from Intune
$appId = Read-Host "Please enter the Intune App ID"

# Retrieve the app name using the App ID
$appName = Get-AppName -appId $appId

if (-not $appName) {
    Write-Host "Error: Invalid App ID. Exiting..." -ForegroundColor Red
    exit 1
}

# Prompt the user for app assignment type (Required, Available, Uninstalled, Cancel)
$assignmentType = $null
do {
    $assignmentType = Read-Host "Do you want to make the app '$appName' Required, Available, Uninstalled, or Cancel? (R/A/U/C)"
    switch ($assignmentType.ToUpper()) {
        'R' { $assignmentType = "Required"; break }
        'A' { $assignmentType = "Available"; break }
        'U' { $assignmentType = "Uninstalled"; break }
        'C' {
            Write-Host "Action cancelled by user." -ForegroundColor Yellow
            exit 0
        }
        default { Write-Host "Invalid input. Please enter 'R', 'A', 'U', or 'C'." -ForegroundColor Yellow }
    }
} until ($assignmentType)

# Confirm with the user if they want to proceed
$confirmation = Read-Host "Are you sure you want to make '$appName' $assignmentType for group '$Global:groupNameG'? (Y/N)"

if ($confirmation.ToUpper() -ne 'Y') {
    Write-Host "Action cancelled by user." -ForegroundColor Yellow
    exit 0
}

# Assign the app to the group based on the user's choice
try {
    # Define assignment settings
    $assignmentSettings = switch ($assignmentType) {
        "Required"   { @{ intent = "required"; } }
        "Available"  { @{ intent = "available"; } }
        "Uninstalled" { @{ intent = "uninstall"; } }
        default { @{ intent = "available"; } }  # Default to "Available" if something goes wrong
    }

    # Create the assignment request
    $appAssignment = @{
        "target" = @{
            "@odata.type" = "#microsoft.graph.groupAssignmentTarget"
            "groupId"     = $Global:groupId
        }
        "intent" = $assignmentSettings.intent
    }

    # Assign the app to the group
    New-MgBetaManagedAppAssignment -ManagedAppId $appId -BodyParameter $appAssignment

    # Log success
    LogSuccess -TaskName "assignApp" -Message "Assigned '$appName' as '$assignmentType' to group '$Global:groupNameG'."
    Write-Host "Successfully assigned '$appName' as '$assignmentType' to group '$Global:groupNameG'." -ForegroundColor Green

} catch {
    Write-Host "Error: Failed to assign the app. $_" -ForegroundColor Red
    LogError -TaskName "assignApp" -ErrorMessage "Failed to assign '$appName' as '$assignmentType' to group '$Global:groupNameG'. $_"
    exit 1
}

exit 0
