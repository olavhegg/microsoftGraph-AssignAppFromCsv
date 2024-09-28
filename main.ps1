# Load necessary functions
. "$PSScriptRoot/scripts/handlers/TaskHandler.ps1"
. "$PSScriptRoot/scripts/connection/ConnectGraph.ps1"
. "$PSScriptRoot/scripts/connection/DisconnectGraph.ps1"
. "$PSScriptRoot/scripts/handlers/ShowCompletion.ps1"
. "$PSScriptRoot/scripts/handlers/LogHandler.ps1"
. "$PSScriptRoot/scripts/helpFunctions/CheckGraph.ps1"
. "$PSScriptRoot/scripts/handlers/ShowIntro.ps1"  

# Show intro after loading functions
ShowIntro

# Ensure Microsoft Graph module is imported
#CheckGraph

# Global Yes flag
$GlobalYes = $false

$Global:groupId = $null
$Global:groupNameG = $null

# Connect to Microsoft Graph
$connection = ConnectToGraph -Scopes @(
    "DeviceManagementManagedDevices.ReadWrite.All",  
    "Group.ReadWrite.All",                           
    "GroupMember.ReadWrite.All",                     
    "Directory.Read.All",                            
    "Device.ReadWrite.All",                          
    "Directory.AccessAsUser.All"                     
)

if (-not $connection) {
    Write-Host "Error: Failed to connect to Microsoft Graph." -ForegroundColor Red
    exit 1
}

# Task order for completion summary
$TaskOrder = @(
    "collectEntraObjectIDs.ps1",
    "createGroup.ps1",
    "populateGroup.ps1",
    "assignApp.ps1"
)

# Track task results
$TaskResults = @{}

try {
    # Path to the scripts folder
    $scriptsFolder = "$PSScriptRoot/scripts"

    # Run tasks
    RunTask -TaskName "collectEntraObjectIDs.ps1" -ScriptPath "$scriptsFolder/collectEntraObjectIDs.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes)
    RunTask -TaskName "createGroup.ps1" -ScriptPath "$scriptsFolder/createGroup.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes)
    RunTask -TaskName "populateGroup.ps1" -ScriptPath "$scriptsFolder/populateGroup.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes) 
    RunTask -TaskName "assignApp.ps1" -ScriptPath "$scriptsFolder/assignApp.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes)

} finally {
    # Disconnect from Microsoft Graph
    DisconnectFromGraph
    ShowCompletion -TaskResults $TaskResults -TaskOrder $TaskOrder
}
