<!-- ABOUT THE PROJECT -->
## About The Project
# Find Inactive Accounts in Active Directory

## System Requirements
- **PowerShell version**: 5.1.19041.2364

---

## About the Script

**Author**: Fardin Barashi  
**Title**: `Find Inactive Accounts in Active Directory`  
**Version**: 1.0  
**Release Date**: 2023-01-31  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## Description

This PowerShell script is used to identify **inactive user accounts** in Active Directory within the last **90 days**, and export the results to a CSV file.

### Features

- Queries Active Directory for user accounts that have been inactive for 90 days.
- Exports:
  - `SamAccountName`
  - `Name`
  - `DistinguishedName`
- Output saved to:  
  `Files\InactiveAccounts.csv`
- Automatically:
  - Starts and stops a transcript log.
  - Logs the script run to the `Logs\` directory with a timestamped filename.
- Basic error handling and script exit if failures occur.

---

<!-- GETTING STARTED -->
## Configuration

No external modules are required beyond standard Active Directory cmdlets.

Make sure the script is run in a PowerShell session with **elevated privileges** and **Active Directory module** loaded.

Directory structure is expected to include:

- `Logs\` — for transcript logs
- `Files\` — where the result CSV will be saved

---

<!-- LICENSE -->
## License

Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.

---

<!-- CONTACT -->
## Contact

LinkedIn - [Fardin Barashi](https://www.linkedin.com/in/fardin-barashi-a56310a2/)
