# This function adds a device to a specified group, checking first if the device is already a member.

. "$PSScriptRoot/Get-IntuneGroupMembers.ps1"

function Add-DeviceToGroup {
    param (
        [string]$groupId,
        [string]$deviceId
    )

    # Check if the device is already in the group
    $existingMembers = Get-GroupMembers -groupId $groupId
    if ($existingMembers | Where-Object { $_.id -eq $deviceId }) {
        LogSuccess -TaskName "Add-DeviceToGroup" -Message "Device $deviceId is already in the group $groupId."
        return
    }

    # Prepare request body to add the device to the group
    $params = @{
        "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$deviceId"
    }

    try {
        # Add the device to the group
        New-MgBetaGroupMemberByRef -GroupId $groupId -BodyParameter $params -ErrorAction Stop | Out-Null
        LogSuccess -TaskName "Add-DeviceToGroup" -Message "Device $deviceId added to group $groupId."
    } catch {
        LogError -TaskName "Add-DeviceToGroup" -ErrorMessage "Failed to add device $deviceId to group $groupId : $_"
    }
}
