# Load the functions from the 'groupFunctions' folder
. "$PSScriptRoot/helpFunctions/PromptForGroupName.ps1"
. "$PSScriptRoot/helpFunctions/CheckIfGroupExists.ps1"
. "$PSScriptRoot/helpFunctions/CreateGroup.ps1"
. "$PSScriptRoot/handlers/LogHandler.ps1"

# Prompt for group name
$groupName = PromptForGroupName

if (-not $groupName) {
    Write-Host "Error: Invalid group name." -ForegroundColor Red
    LogError -TaskName "createGroup" -ErrorMessage "Invalid group name provided."
    exit 1
}

# Check if the group already exists
$groupExists, $groupId = CheckIfGroupExists -groupName $groupName

if ($groupExists) {
    Write-Host "Group '$groupName' already exists in Microsoft Graph." -ForegroundColor Yellow
    LogSuccess -TaskName "createGroup" -Message "Group '$groupName' already exists. Group ID: $groupId"
} else {
    Write-Host "Group '$groupName' does not exist. Creating the group..."

    # Create the group
    $groupId = CreateGroup -groupName $groupName

    if (-not $groupId) {
        Write-Host "Error: Failed to create the group." -ForegroundColor Red
        LogError -TaskName "createGroup" -ErrorMessage "Failed to create group '$groupName'."
        exit 1
    }

    Write-Host "Group '$groupName' has been successfully created with Group ID: $groupId." -ForegroundColor Green
    LogSuccess -TaskName "createGroup" -Message "Successfully created group '$groupName'. Group ID: $groupId"
}

$Global:groupId = $groupId
exit 0
