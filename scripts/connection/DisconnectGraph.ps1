# Function to disconnect from Microsoft Graph
function DisconnectFromGraph {
    try {
        Disconnect-MgGraph
        Write-Host "Disconnected from Microsoft Graph."
    } catch {
        Write-Host "Error disconnecting from Microsoft Graph: $_" -ForegroundColor Red
        Write-Host "Full error details: $($_.Exception.Message)"
    }
}
