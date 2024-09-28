# This script handles task execution, user prompts, and progress tracking for each task.

function RunTask {
    param (
        [string]$TaskName,         # Name of the task
        [string]$ScriptPath,       # Path to the script
        [hashtable]$TaskResults,   # Hashtable to track task results
        [ref]$GlobalYes = $false   # Reference to skip future prompts
    )

    $TaskDisplayName = $TaskName  # Store task name for printing
    $TaskResults[$TaskDisplayName] = "Pending"

    # Task-specific descriptions
    $taskDescription = switch ($TaskName) {
        "collectEntraObjectIDs.ps1" { "Do you want to collect EntraObjectIDs?" }
        "populateGroup.ps1" { "Do you want to populate the group with members?" }
        "assignApp.ps1" { "Do you want to assign apps to the group?" }
        default { $null }
    }

    # Handle user prompts unless global "Yes" is set
    if (-not $GlobalYes.Value -and $taskDescription) {
        do {
            Write-Host "`n$taskDescription (Y/y/n/c)" -ForegroundColor Green
            Write-Host "Y = Yes to all remaining tasks, y = Yes, n = No (Skip), c = Cancel" -ForegroundColor Green
            $taskAction = Read-Host

            switch ($taskAction) {
                'y' {
                    Write-Host "`nProceeding with task: $TaskDisplayName..." -ForegroundColor Green
                    break
                }
                'n' {
                    Write-Host "`n--------------------------------------------------------" -ForegroundColor Blue
                    Write-Host "Skipped task: $TaskDisplayName." -ForegroundColor Blue
                    Write-Host "--------------------------------------------------------" -ForegroundColor Blue
                    $TaskResults[$TaskDisplayName] = 'Skipped'
                    return
                }
                'c' {
                    Write-Host "`n--------------------------------------------------------" -ForegroundColor Red
                    Write-Host "Process canceled by the user." -ForegroundColor Red
                    Write-Host "--------------------------------------------------------" -ForegroundColor Red
                    $TaskResults[$TaskDisplayName] = 'Cancelled'
                    exit 4
                }
                'Y' {
                    Write-Host "`nProceeding with all remaining tasks without further prompts." -ForegroundColor Green
                    $GlobalYes.Value = $true
                    break
                }
                default {
                    Write-Host "Invalid input. Please enter 'y', 'n', 'c', or 'Y'." -ForegroundColor Red
                }
            }
        } until ($taskAction -eq 'y' -or $taskAction -eq 'n' -or $taskAction -eq 'c' -or $taskAction -eq 'Y')
    }

    # Execute the task
    Write-Host "`n--------------------------------------------------------" -ForegroundColor Green
    Write-Host "Starting task: $TaskDisplayName" -ForegroundColor Blue
    Write-Host "--------------------------------------------------------`n" -ForegroundColor Green
    try {
        & $ScriptPath
        $TaskResults[$TaskDisplayName] = 'Success'
        Write-Host "`nTask '$TaskDisplayName' completed successfully." -ForegroundColor Green
    } catch {
        $TaskResults[$TaskDisplayName] = 'Failed'
        Write-Host "`nTask '$TaskDisplayName' failed with error: $_" -ForegroundColor Red
        LogError -TaskName $TaskDisplayName -ErrorMessage $_
        return 1
    }
}
