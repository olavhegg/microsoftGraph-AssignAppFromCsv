# Function to connect to Microsoft Graph with specified scopes and log errors
function ConnectToGraph {
    param (
        [string[]]$Scopes
    )

    if (-not $Scopes -or $Scopes.Count -eq 0) {
        Write-Host "Error: No scopes provided." -ForegroundColor Red
        LogError -TaskName "ConnectToGraph" -ErrorMessage "No scopes provided."
        return $null
    }

    try {
        $connection = Connect-MgGraph -Scopes $Scopes -ErrorAction Stop

        if ($connection) {
            Write-Host "Connected to Microsoft Graph." -ForegroundColor Green
            LogSuccess -TaskName "ConnectToGraph" -Message "Successfully connected to Microsoft Graph."
            return $connection
        } else {
            Write-Host "Failed to connect to Microsoft Graph." -ForegroundColor Red
            LogError -TaskName "ConnectToGraph" -ErrorMessage "Failed to connect to Microsoft Graph."
            return $null
        }
    } catch {
        Write-Host "Error connecting to Microsoft Graph." -ForegroundColor Red
        LogError -TaskName "ConnectToGraph" -ErrorMessage $_.Exception.Message
        return $null
    }
}
