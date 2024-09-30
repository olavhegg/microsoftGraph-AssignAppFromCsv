# Is-DeviceManagedBySCCM.ps1
function Is-DeviceManagedBySCCM {
    param (
        [object]$ManagedDevices
    )

    foreach ($device in $ManagedDevices) {
        # Check for various management types that might indicate SCCM or Co-managed
        if ($device.ManagementAgent -eq "ConfigMgr" -or $device.ManagementAgent -eq "SCCM" -or $device.ManagementAgent -eq "Co-Managed") {
            return $device.ManagementAgent  # Return the actual management type
        }
    }
    return $null  # If not managed by SCCM or Co-managed
}
