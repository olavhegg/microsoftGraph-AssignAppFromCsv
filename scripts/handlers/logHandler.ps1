# This script handles logging for tasks, writing to separate log files based on task success or failure.

# Log error messages to task-specific log files
function LogError {
    param (
        [string]$TaskName,       # Name of the task that encountered an error
        [string]$ErrorMessage    # Error message to log
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
}

# Log successful events to a general success log
function LogSuccess {
    param (
        [string]$TaskName,   # Name of the task that succeeded
        [string]$Message     # Success message to log
    )

    $logFilePath = "./logs/GeneralSuccessLog.txt"
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - Task: $TaskName - Success: $Message"

    Add-Content -Path $logFilePath -Value $logMessage
}
