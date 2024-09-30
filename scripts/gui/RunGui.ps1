# RunGui.ps1: Main GUI file for Intune App Assignment Automation Tool

# Load necessary .NET types for Windows Forms
try {
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
} catch {
    Write-Host "Error: Could not load required assemblies. Ensure that .NET is installed properly." -ForegroundColor Red
    exit 1
}

# Load the ShowWelcomeScreen and ShowPoweredByLabel functions
. "$PSScriptRoot/ShowWelcomeGui.ps1"
. "$PSScriptRoot/ShowPoweredByLabel.ps1"

# Create the main form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Intune App Assignment Automation Tool"
$form.Size = New-Object System.Drawing.Size(800, 400)  # Wider and less tall for a better layout
$form.StartPosition = "CenterScreen"
$form.FormBorderStyle = 'FixedSingle'
$form.MaximizeBox = $false

# Load the disconnect function for when the form closes
. "$PSScriptRoot/../connection/DisconnectGraph.ps1"

# Handle window close event to disconnect from Microsoft Graph
$form.add_FormClosing({
    try {
        DisconnectFromGraph
    } catch {
        Write-Host "Error during disconnection from Microsoft Graph." -ForegroundColor Red
    }
})

# Call functions to display the welcome screen and powered by label
try {
    ShowWelcomeScreen -form ([ref]$form)
    ShowPoweredByLabel -form ([ref]$form)
} catch {
    Write-Host "Error: Issue with displaying the form." -ForegroundColor Red
    exit 1
}

# Show the form dialog
$form.ShowDialog()
