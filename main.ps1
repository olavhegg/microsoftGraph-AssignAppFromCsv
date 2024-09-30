# Load necessary functions
. "$PSScriptRoot/scripts/handlers/TaskHandler.ps1"
. "$PSScriptRoot/scripts/connection/ConnectGraph.ps1"
. "$PSScriptRoot/scripts/connection/DisconnectGraph.ps1"
. "$PSScriptRoot/scripts/handlers/ShowCompletion.ps1"
. "$PSScriptRoot/scripts/handlers/LogHandler.ps1"
. "$PSScriptRoot/scripts/handlers/ShowIntro.ps1"

# Define if GUI mode is to be used
$UseGUI = $false  # Set to $false to use CLI

if ($UseGUI) {
    # Load the GUI wrapper if GUI mode is enabled
    . "$PSScriptRoot/scripts/gui/RunGui.ps1"
    exit 0  # Exit after GUI
}

# Display intro and ensure Microsoft Graph is imported
ShowIntro

# Initialize global variables
$GlobalYes = $false
$Global:groupId = $null
$Global:groupNameG = $null

# Connect to Microsoft Graph with necessary scopes
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

# Define task order for summary
$TaskOrder = @(
    "collectEntraObjectIDs.ps1",
    "createGroup.ps1",
    "populateGroup.ps1",
    "assignApp.ps1"
)

# Track task results
$TaskResults = @{}

try {
    $scriptsFolder = "$PSScriptRoot/scripts"

    # Run tasks in sequence
    RunTask -TaskName "collectEntraObjectIDs.ps1" -ScriptPath "$scriptsFolder/collectEntraObjectIDs.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes)
    RunTask -TaskName "createGroup.ps1" -ScriptPath "$scriptsFolder/createGroup.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes)
    RunTask -TaskName "populateGroup.ps1" -ScriptPath "$scriptsFolder/populateGroup.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes)
    RunTask -TaskName "assignApp.ps1" -ScriptPath "$scriptsFolder/assignApp.ps1" -TaskResults $TaskResults -GlobalYes ([ref]$GlobalYes)

} finally {
    # Disconnect from Microsoft Graph and show completion
    DisconnectFromGraph
    ShowCompletion -TaskResults $TaskResults -TaskOrder $TaskOrder
}
