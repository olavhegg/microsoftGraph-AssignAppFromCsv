# This function checks whether a group with a specified name already exists in Microsoft Graph.

function CheckIfGroupExists {
    param (
        [string]$groupName
    )

    $groupCheckUrl = "https://graph.microsoft.com/beta/groups?`$filter=displayName eq '$groupName'"

    try {
        $groupResult = Invoke-MgGraphRequest -Method GET -Uri $groupCheckUrl

        if ($groupResult.value.Count -gt 0) {
            $groupId = $groupResult.value[0].id
            return $true, $groupId
        } else {
            return $false, $null
        }
    } catch {
        Write-Host "Error checking for group existence: $_" -ForegroundColor Red
        return $false, $null
    }
}
