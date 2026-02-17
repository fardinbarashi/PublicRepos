# Powershell Scripts Documentation

This README provides a comprehensive documentation of all PowerShell scripts organized by category.

## Categories

### 1. System Administration
- **Get-SystemInfo.ps1**: A script that gathers and displays system information.
- **Manage-Services.ps1**: Script for starting, stopping, and managing Windows services.

### 2. Network Management
- **Test-NetworkConnection.ps1**: Tests network connectivity to a specified host.
- **Get-NetworkAdapters.ps1**: Lists all network adapters and their status.

### 3. User Management
- **Create-User.ps1**: Script to create a new user in Active Directory.
- **Remove-User.ps1**: Script to delete a user from Active Directory.

### 4. File Management
- **Copy-Files.ps1**: Copies files from one directory to another.
- **Remove-OldFiles.ps1**: Deletes files older than a specified date.

### 5. Monitoring
- **Monitor-CPUUsage.ps1**: Monitors CPU usage and alerts if it exceeds a threshold.
- **Log-Event.ps1**: Logs custom events to the Windows Event Log.

## Usage
To run a script, open PowerShell and execute the following command:

```powershell
.
<ScriptName>.ps1
```

Make sure to configure execution policies if necessary.

## Contributing
Contributions are welcomed! Please review the guidelines for contributing before making any changes.

## License
This repository is licensed under the MIT License.
