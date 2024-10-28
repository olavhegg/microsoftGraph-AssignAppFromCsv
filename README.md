# Automated Application Assignment via Group Management from CSV

This PowerShell-based automation tool simplifies the process of assigning applications to devices by automating group creation and population based on device data from a CSV file. The system leverages Microsoft Graph to create Azure AD groups, populate them with devices using their EntraObjectIDs, and assign applications to these groups via Microsoft Intune.

## Baseline Goal

The primary goal of this project is to **automate the process of assigning applications** to devices through group assignments based on a provided CSV file. The application assignment can be defined as **Required**, **Available**, or **Uninstalled**, allowing administrators to manage applications on devices efficiently.

---

## CSV File Structure

The external CSV file containing device information must be in the following format:

```
Name,Operating System,Software last seen,Installed Versions
device1,Windows 11,"19 Sep, 2024 08:10:44 AM","1.7.0.1864, 1.5.0.4689"
device2,Windows 11,"18 Sep, 2024 02:24:47 PM","1.7.0.21751, 1.7.0.156, 1.5.0.30767"
```

The **Name** field is used to query Microsoft Graph for the device’s EntraObjectID. Ensure the file follows this structure, with each field separated by a comma.

### Important:
- The first row of the CSV file must follow this exact structure:  
  `Name,Operating System,Software last seen,Installed Versions`
- The CSV file should be placed in the root directory of the project with the name **`ExternalDevices.csv`**.

---

## Directory Structure

Below is the directory structure for this project:

```
/
├── files/                               # Directory for saving output files
│   ├── EntraObjectIDs.csv               # CSV containing collected EntraObjectIDs
│   ├── DevicesWithoutEntraObjectIds.csv # CSV containing devices without valid EntraObjectIDs
├── logs/                                # Directory for task-specific logs
│   ├── CollectEntraObjectIDsLog.txt     # Log for EntraObjectID collection task
│   ├── CreateGroupLog.txt               # Log for group creation task
│   ├── PopulateGroupLog.txt             # Log for group population task
│   ├── AssignAppLog.txt                 # Log for app assignment task
│   ├── GeneralErrorLog.txt              # General error log
│   ├── GeneralSuccessLog.txt            # General success log
├── scripts/
│   ├── connection/
│   │   ├── ConnectGraph.ps1             # Script to connect to Microsoft Graph
│   │   ├── DisconnectGraph.ps1          # Script to disconnect from Microsoft Graph
│   ├── handlers/
│   │   ├── TaskHandler.ps1              # Manages task execution and prompts
│   │   ├── ErrorHandler.ps1             # Centralized error handler for tasks
│   │   ├── LogHandler.ps1               # Handles logging for tasks
│   │   ├── ShowIntro.ps1                # Displays the intro message
│   │   ├── ShowCompletion.ps1           # Displays the completion summary
│   ├── helpFunctions/
│   │   ├── Add-DeviceToGroup.ps1        # Adds devices to Microsoft Graph group
│   │   ├── CheckIfGroupExists.ps1       # Checks if a group exists in Microsoft Graph
│   │   ├── CreateGroup.ps1              # Creates a new group in Microsoft Graph
│   │   ├── Get-AppName.ps1              # Retrieves app name from Intune App ID
│   │   ├── Get-DeviceObjectId.ps1       # Retrieves EntraObjectID from device name
│   │   ├── Get-IntuneGroupMembers.ps1   # Fetches group members from Microsoft Graph
│   │   ├── PromptForGroupName.ps1       # Prompts for a group name suffix
│   ├── collectEntraObjectIDs.ps1        # Collects EntraObjectIDs from Microsoft Graph
│   ├── createGroup.ps1                  # Creates a group in Microsoft Graph
│   ├── populateGroup.ps1                # Populates a group with devices
│   ├── assignApp.ps1                    # Assigns an app to the created group in Microsoft Intune
├── ExternalDevices.csv                  # External CSV containing device data (input file)
├── main.ps1                             # Main script to execute the automation workflow
└── README.md                            # This README file
```

---

## Prerequisites

1. **PowerShell 7.0+**: Ensure you have PowerShell 7.0 or higher installed.
2. **Microsoft Graph SDK**:
   - Install the Microsoft Graph SDK using the following command:
     ```bash
     Install-Module Microsoft.Graph -Scope CurrentUser
     ```
3. **Required Permissions**: Ensure your Azure AD App Registration has the following permissions:
   - `DeviceManagementManagedDevices.ReadWrite.All`
   - `Group.ReadWrite.All`
   - `GroupMember.ReadWrite.All`
   - `Directory.Read.All`
   - `Device.ReadWrite.All`
   - `Directory.AccessAsUser.All`

---

## Running the Scripts

### Step 1: Prepare the External CSV

- Place the CSV file (`ExternalDevices.csv`) in the root directory of the project.
- Ensure the file follows the correct format (as mentioned above).

### Step 2: Execute the Main Script

The `main.ps1` script orchestrates the entire process, executing each task sequentially.

```bash
pwsh scripts/main.ps1
```

You will be prompted for several inputs as part of the automation workflow:
1. Whether to collect EntraObjectIDs.
2. Whether to create a group or populate an existing group.
3. Whether to assign applications to the group.

### Step 3: Review Logs

After running the script, check the logs in the `logs/` folder for details about each task's execution:
- Success and failure logs are separated for easier review.
- The logs are useful for troubleshooting any issues that arise during the process.

---

## Task Flow

1. **Collect EntraObjectIDs**: Queries Microsoft Graph for each device in `ExternalDevices.csv` and stores the corresponding EntraObjectIDs in `EntraObjectIDs.csv`.
2. **Create Group**: Prompts for a group name suffix and either creates a new group or uses an existing one in Microsoft Graph.
3. **Populate Group**: Populates the created or existing group with devices using the collected EntraObjectIDs.
4. **Assign App**: Prompts for an Intune App ID and assigns the app to the group as "Required", "Available", or "Uninstalled".

---

## Customization

You can modify the tasks and prompts easily by editing the relevant task scripts in the `scripts/` folder. The modular structure ensures that each task can be customized without affecting the entire workflow.

---

## Known Issues

- Assign App functionality is not completed!!!
- Ensure the `ExternalDevices.csv` file is formatted correctly and is placed in the correct location.
- The script expects the `Name` field in the CSV to match the display name of devices in Microsoft Graph.

---


### Author

**Olav Heggelund**
