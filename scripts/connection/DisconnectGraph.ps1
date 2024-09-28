# This function disconnects from Microsoft Graph and logs the result.

function DisconnectFromGraph {
    try {
        # Attempt to disconnect from Microsoft Graph
        Disconnect-MgGraph
        
        Write-Host "Disconnected from Microsoft Graph." -ForegroundColor Green
        LogSuccess -TaskName "DisconnectFromGraph" -Message "Successfully disconnected from Microsoft Graph."
    } catch {
        Write-Host "Error disconnecting from Microsoft Graph." -ForegroundColor Red
        LogError -TaskName "DisconnectFromGraph" -ErrorMessage $_.Exception.Message
    }
}
