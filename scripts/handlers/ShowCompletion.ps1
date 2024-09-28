# ShowCompletion.ps1: Function to print the completion summary

function ShowCompletion {
    param (
        [hashtable]$TaskResults,
        [array]$TaskOrder  
    )

    Write-Host "`n--------------------------------------------------------" -ForegroundColor Green
    Write-Host "Process complete." -ForegroundColor Green

    # Print task summary
    foreach ($task in $TaskOrder) {
        if ($TaskResults.ContainsKey($task)) {
            $taskStatus = $TaskResults[$task]
            switch ($taskStatus) {
                'Success' { Write-Host "$($task): Completed successfully." -ForegroundColor Green }
                'Failed'  { Write-Host "$($task): Failed." -ForegroundColor Red }
                'Skipped' { Write-Host "$($task): Skipped." -ForegroundColor Yellow }
                'Cancelled' { Write-Host "$($task): Cancelled." -ForegroundColor Red }
                default   { Write-Host "$($task): Unknown status." -ForegroundColor Yellow }
            }
        }
    }
    Write-Host "--------------------------------------------------------`n" -ForegroundColor Green
}
