<!-- ABOUT THE PROJECT -->
## About The Project
# Export AD Objects to CSV and HTML Reports

## System Requirements
- **PowerShell version**: 5.1.19041.2364  


---

## About the Script
**Author**: Fardin Barashi  
**Title**: `Export AD Objects to CSV and HTML Reports`  
**Version**: 1.0  
**Release Date**: 2023-01-31  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## Description

This PowerShell script exports **Active Directory Users**, **Groups**, and **Computers** from a specified **Organizational Unit (OU)**. It generates:

- CSV reports for each object type
- HTML reports with table styling
- Execution logs via transcript

### Features

- Exports data for:
  - Users: name, type, last logon, status, OU path
  - Groups: name, description, members, owner, creation dates
  - Computers: name, OS, IP, last logon, timestamps
- Creates both `.csv` and styled `.html` reports
- Auto-generates folders if missing:
  - `Files\CsvFiles\`
  - `Files\HtmlReportFiles\`
  - `Logs\`
- Custom HTML styles included for easy reading
- Includes logging and error handling

---

<!-- GETTING STARTED -->
## Configuration

### 1. Set the Search OU

In the script, locate the following variable and update it with your target OU:
Change the row 47 $SearchOu = "" to the OU distinguishedName that you want to look on. 

```powershell
$SearchOu = "OU=ExampleOU,DC=yourdomain,DC=local"
