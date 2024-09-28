# CheckGraph.ps1: Checks if the Microsoft Graph module is imported; imports if not

function CheckGraph {
    try {
        Import-Module Microsoft.Graph.Beta -ErrorAction Stop
        Write-Host "Microsoft Graph Beta module imported successfully." -ForegroundColor Green
        LogSuccess -TaskName "Main" -Message "Microsoft Graph Beta module imported successfully."
    } catch {
        Write-Host "Error importing Microsoft Graph Beta module: $_" -ForegroundColor Red
        LogError -TaskName "Main" -ErrorMessage "Failed to import Microsoft Graph Beta module: $_"
        exit 1
    }
}
