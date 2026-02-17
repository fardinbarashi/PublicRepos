# PowerShell Scripts Documentation

This README provides comprehensive documentation of all PowerShell scripts organized by category. Each script's purpose, usage examples, and system requirements are included below.

## 1. Active Directory Management
### Script Name: `Manage-ADUsers.ps1`
**Purpose:** This script allows administrators to create, modify, and delete Active Directory users.  
**Usage:**  
```powershell
.[Manage-ADUsers.ps1 -Action Create -Username "jdoe" -Password "P@ssw0rd" 
```
**System Requirements:**  
- Windows Server with Active Directory module installed  

### Script Name: `Export-ADGroupMembers.ps1`
**Purpose:** Exports the members of a specified Active Directory group to a CSV file.
**Usage:**  
```powershell
.[Export-ADGroupMembers.ps1 -GroupName "AdminGroup" -OutputPath "C:\ADGroupMembers.csv"
```
**System Requirements:**  
- Windows Server with Active Directory module installed

## 2. ADFS Operations
### Script Name: `Get-ADFSToken.ps1`
**Purpose:** Retrieves a token from the ADFS server for specified user credentials.
**Usage:**  
```powershell
.[Get-ADFSToken.ps1 -Username "jdoe" -Password "P@ssw0rd"
```
**System Requirements:**  
- ADFS server access

## 3. Security Scripts
### Script Name: `Invoke-SecurityAudit.ps1`
**Purpose:** Performs a security audit of the specified system and generates a report.
**Usage:**  
```powershell
.[Invoke-SecurityAudit.ps1 -ComputerName "Server01" -ReportPath "C:\SecurityAuditReport.txt"
```
**System Requirements:**  
- Windows PowerShell

## 4. Useful Snippets
### Script Name: `Check-ServiceStatus.ps1`
**Purpose:** Checks the status of a specified service on the local machine.
**Usage:**  
```powershell
.[Check-ServiceStatus.ps1 -ServiceName "wuauserv"
```
**System Requirements:**  
- Windows PowerShell

---

Ensure to follow the proper guidelines and prerequisites before executing the scripts mentioned above.  
For further details about each script, refer to the inline comments provided within each script file itself.

---