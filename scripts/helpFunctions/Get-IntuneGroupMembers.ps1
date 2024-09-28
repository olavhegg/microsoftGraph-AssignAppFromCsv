function Get-GroupMembers {
    param (
        [string]$groupId,
        [string]$query = $null
    )

    $graphUri = if ($query) {
        "https://graph.microsoft.com/beta/groups/$groupId/members?$query"
    } else {
        "https://graph.microsoft.com/beta/groups/$groupId/members"
    }

    Invoke-MgGraphRequest -Uri $graphUri -Method "GET"
}
