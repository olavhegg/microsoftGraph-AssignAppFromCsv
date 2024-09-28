# LogHandler.ps1: Handles logging for different tasks into separate log files

function LogError {
    param (
        [string]$TaskName,       
        [string]$ErrorMessage    
    )

    # Determine log file based on task
    $logFilePath = switch ($TaskName) {
        "collectEntraObjectIDs.ps1" { "./logs/CollectEntraObjectIDsLog.txt" }
        "createGroup.ps1" { "./logs/CreateGroupLog.txt" }
        "populateGroup.ps1" { "./logs/PopulateGroupLog.txt" }
        "assignApp.ps1" { "./logs/AssignAppLog.txt" }
        default { "./logs/GeneralErrorLog.txt" }  # General log file for any other tasks
    }

    # Format log message with timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - Task: $TaskName - Error: $ErrorMessage"
    
    # Write log message to the respective log file
    Add-Content -Path $logFilePath -Value $logMessage
    #Write-Host "Error logged to $logFilePath" -ForegroundColor Yellow
}

# Function to log successful events
function LogSuccess {
    param (
        [string]$TaskName,
        [string]$Message
    )

    $logFilePath = "./logs/GeneralSuccessLog.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - Task: $TaskName - Success: $Message"

    Add-Content -Path $logFilePath -Value $logMessage
}
