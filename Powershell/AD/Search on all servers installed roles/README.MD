<!-- ABOUT THE PROJECT -->
## About The Project
# Get All Windows Server and Roles

## System Requirements
- **PowerShell version**: 5.1.19041.2364  

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## About the Script
**Author**: Fardin Barashi  
**Title**: `Get all windows server and roles`  
**Version**: 1.0  
**Release Date**: 2024-12-20  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## Description

This PowerShell script queries every **Windows Server** within your Active Directory environment and retrieves all the **installed roles and features**. It's designed to help administrators quickly assess server configurations in their infrastructure.

The script produces:

- A CSV file listing each server along with installed roles and features.
- Detailed transcript logs of script execution for troubleshooting and auditing.

### Features

- Automatically retrieves server details directly from Active Directory.
- Remotely queries servers to list installed roles and features.
- Outputs detailed results into an easily readable CSV file.
- Logs all operations, successes, and failures in transcript files.

---

<!-- GETTING STARTED -->
## Configuration

### 1. Output File Location

By default, the script saves the CSV file at the following location:

```powershell
C:\Temp\WindowsServerRoles.csv



