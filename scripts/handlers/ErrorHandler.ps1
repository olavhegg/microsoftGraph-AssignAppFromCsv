# This script provides centralized error handling for tasks based on their exit codes.

function HandleTaskError {
    param (
        [string]$TaskName,   # Name of the task that encountered an error
        [int]$ExitCode       # Exit code returned by the task
    )

    # Display error messages based on the exit code
    switch ($ExitCode) {
        1 { Write-Host "Error: '$TaskName' failed due to CSV load/format issues." -ForegroundColor Red }
        2 { Write-Host "Error: '$TaskName' failed during device fetching or comparison." -ForegroundColor Red }
        3 { Write-Host "Error: '$TaskName' failed while saving the file." -ForegroundColor Red }
        5 { Write-Host "Error: Group creation failed due to existing group or name issue." -ForegroundColor Red }
        6 { Write-Host "Error: Group population failed." -ForegroundColor Red }
        9 { Write-Host "Error: '$TaskName' failed due to issues with collecting EntraObjectIDs." -ForegroundColor Red }
        default { Write-Host "Error: '$TaskName' encountered an unexpected issue (exit code: $ExitCode)." -ForegroundColor Red }
    }

    # Exit with the error code
    exit $ExitCode
}
