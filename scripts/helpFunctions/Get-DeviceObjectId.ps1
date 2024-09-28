function Get-DeviceObjectId {
    param (
        [string]$DeviceName
    )


    try {
        # Query Microsoft Graph Beta API using Get-MgBetaDevice
        $device = Get-MgBetaDevice -Filter "displayName eq '$DeviceName'" -Property "id"

        # Check if we received a result
        if ($device) {
            return $device.Id
        } else {
            return $null  # No Object ID found for this device name
        }
    } catch {
        Write-Host "Error retrieving ObjectID for $DeviceName : $_" -ForegroundColor Red
        LogError -TaskName "Get-DeviceObjectId" -ErrorMessage "Failed to retrieve ObjectID for $DeviceName : $_"
        return $null
    }
}
