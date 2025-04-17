<!-- ABOUT THE PROJECT -->
## About The Project
# Populate AD Group by Using OU

## System Requirements
- **PowerShell version**: 5.1.19041.2364  
 

---

## About the Script

**Author**: Fardin Barashi  
**Title**: `Populate AD Group by Using OU`  
**Version**: 1.0  
**Release Date**: 2025-01-14  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## Description

This PowerShell script populates a **Base Active Directory Group** with all eligible users from a specified **Organizational Unit (OU)**. It filters users based on their **department**, **OU**, and **existing group memberships**.

### Features

- Reads all users from a defined Base OU
- Filters out users:
  - In excluded OUs
  - Without department values
  - With department values like `ABC` or `DEF`
  - Already in one of the exclusion groups
- Adds eligible users to a target Base AD Group
- Exports group members to CSV (`C:\Temp\Members.csv`)
- Logs all operations to a timestamped transcript

---

<!-- GETTING STARTED -->
## Configuration

### 1. Set the Base OU and Group

Inside the script, configure these variables:

```powershell
$BaseADGroup = "CN=YourGroup,OU=Path,DC=domain,DC=com"
$BaseOu = "OU=YourOU,DC=domain,DC=com"
