. "$PSScriptRoot/Get-IntuneGroupMembers.ps1"

function Add-DeviceToGroup {
    param (
        [string]$groupId,
        [string]$deviceId
    )

    # Load existing group members using Get-IntuneGroupMembers to check if the device is already in the group
    $existingMembers = Get-GroupMembers -groupId $groupId

    # Check if the device is already in the group
    if ($existingMembers | Where-Object { $_.id -eq $deviceId }) {
        LogSuccess -TaskName "Add-DeviceToGroup" -Message "Device $deviceId is already in the group $groupId."
        return
    }

    # Prepare the request body to add the device
    $params = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$deviceId"
    }

    try {
        # Add the device to the group using Microsoft Graph
        New-MgBetaGroupMemberByRef -GroupId $groupId -BodyParameter $params -ErrorAction Stop | Out-Null
        LogSuccess -TaskName "Add-DeviceToGroup" -Message "Device $deviceId added to group $groupId."
    } catch {
        LogError -TaskName "Add-DeviceToGroup" -ErrorMessage "Failed to add device $deviceId to group $groupId : $_"
    }
}
