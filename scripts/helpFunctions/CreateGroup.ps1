function CreateGroup {
    param (
        [string]$groupName
    )

    # Extract the CHG process from the group name (e.g., from 'CUSTOM-AAD-DEVICE-CHG-0189318' to 'CHG0189318')
    $chgProcess = "CHG" + ($groupName -split '-CHG-')[1]

    # Create a custom description for the group
    $groupDescription = "This is an automatically generated group in order to perform $chgProcess."

    $groupBody = @{
        "displayName" = $groupName
        "mailEnabled" = $false
        "mailNickname" = $groupName
        "securityEnabled" = $true
        "groupTypes" = @()
        "description" = $groupDescription
    } | ConvertTo-Json

    try {
        $newGroup = Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/groups" -Body $groupBody -ContentType "application/json"
        $groupId = $newGroup.id
        Write-Host "Group '$groupName' successfully created with ID: $groupId."
        return $groupId
    } catch {
        Write-Host "Error creating the group: $_" -ForegroundColor Red
        return $null
    }
}
