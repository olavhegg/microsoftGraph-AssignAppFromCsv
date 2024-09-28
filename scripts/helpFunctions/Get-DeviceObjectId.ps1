# This function retrieves the Object ID of a device from Microsoft Graph Beta based on its display name.

function Get-DeviceObjectId {
    param (
        [string]$DeviceName
    )

    try {
        # Query Microsoft Graph Beta API using the device name
        $device = Get-MgBetaDevice -Filter "displayName eq '$DeviceName'" -Property "id"

        if ($device) {
            return $device.Id
        } else {
            return $null  # No Object ID found
        }
    } catch {
        Write-Host "Error retrieving ObjectID for $DeviceName : $_" -ForegroundColor Red
        LogError -TaskName "Get-DeviceObjectId" -ErrorMessage "Failed to retrieve ObjectID for $DeviceName : $_"
        return $null
    }
}
