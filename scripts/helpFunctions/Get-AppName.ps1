# This function retrieves the app name from Microsoft Graph Beta using the App ID.

function Get-AppName {
    param (
        [string]$appId
    )

    try {
        $app = Get-MgBetaManagedApp -ManagedAppId $appId
        return $app.DisplayName
    } catch {
        Write-Host "Error: Could not retrieve the app name for App ID $appId." -ForegroundColor Red
        LogError -TaskName "assignApp" -ErrorMessage "Failed to retrieve app name for App ID: $appId"
        return $null
    }
}
