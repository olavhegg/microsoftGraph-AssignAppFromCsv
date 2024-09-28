# This function prompts the user for a suffix and constructs a group name based on it.

function PromptForGroupName {
    while ($true) {
        $suffix = Read-Host "Enter the suffix for the group name (or type 'exit' to quit). The full group name will be: CUSTOM-AAD-DEVICE-CHG-***"

        if ($suffix -eq 'exit') {
            Write-Host "Process canceled by the user." -ForegroundColor Red
            exit 0
        }

        if (![string]::IsNullOrEmpty($suffix)) {
            $groupName = "CUSTOM-AAD-DEVICE-CHG-$suffix"
            $Global:groupNameG = $groupName
            return $groupName
        } else {
            Write-Host "Error: Group name suffix cannot be empty." -ForegroundColor Red
        }
    }
}
