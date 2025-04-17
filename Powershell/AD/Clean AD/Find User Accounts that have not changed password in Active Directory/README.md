<!-- ABOUT THE PROJECT -->
## About The Project
# Get AD Users with Expired or Expiring Passwords And Find Users Who Haven’t Changed Their Password in AD

## System Requirements
- **PowerShell version**: 5.1.19041.2364

## About the Script
**Author**: Fardin Barashi  
**Version**: 1.0  
**Release Date**: 2023-01-31  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

<!-- CONTACT -->
## Contact
LinkedIn - [Fardin Barashi](https://www.linkedin.com/in/fardin-barashi-a56310a2/)

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.

## Get AD Users with Expired or Expiring Passwords
## Description
This PowerShell script retrieves Active Directory user accounts with:
- Expired passwords
- Expired accounts
- Passwords that are about to expire

The script also logs all actions via a transcript and includes basic error handling for each section.

### Features
- **Section 1**: Gets all **enabled** users in a group whose **passwords have expired**.
- **Section 2**: Identifies **disabled accounts** or those with **expired accounts** based on `AccountExpires`.
- **Section 3**: Finds users whose **passwords will expire** within a defined number of days.
- Uses `Get-ADUser` and `Get-ADGroupMember` for AD querying.
- Logs execution details to the `Logs\` directory with timestamped filenames.
- Collects key user attributes including:
  - `givenName`, `sn`, `samAccountName`
  - `PasswordLastSet`, `PasswordNeverExpires`, `PasswordExpired`
  - `AccountExpires`, `LastLogonTimestamp`, `msDS-UserPasswordExpiryTimeComputed`
- Output can be easily adapted to export or notify users/admins.

---

<!-- GETTING STARTED -->
## Configuration

1. **Set AD Group Names**:  
   Update the variables `$AdGroup` and `$AddToAdGroupNotify` to target the correct Active Directory groups.

2. **Set Password Expiry Threshold** (Section 3):  
   Define `$PasswordValueDays` to specify how soon before expiry a user should be flagged.

3. **Directory Structure**:  
   Ensure the following folders exist in the script path:
   - `Logs\` — for transcript logging
   - `Files\` *(optional)* — if you plan to export data

4. **Permissions**:  
   Run the script with sufficient privileges to query user attributes in Active Directory.



## Find Users Who Haven’t Changed Their Password in AD
## Description
This PowerShell script identifies users in **Active Directory** whose **passwords have expired** but have **not changed them** within the expected password age defined in the domain's password policy.

### Features

- Fetches users with expired passwords using `Search-AdAccount`.
- Compares `PasswordLastSet` to the domain’s **maximum password age**.
- Filters out users who have changed their password within policy.
- Exports the results to:  
  `Files\PassWordExpiredAccounts.csv`
- Starts and ends a transcript log saved in `Logs\` directory.
- Basic error handling and graceful exit on failure.

---

<!-- GETTING STARTED -->
## Configuration

1. **Directory Structure**:
   - Create the following folders in the script path:
     - `Logs\` — for transcript logs
     - `Files\` — for the CSV export

2. **Permissions**:
   - Script must be run with sufficient privileges to read user attributes in Active Directory.

3. **AD Module**:
   - Make sure the **Active Directory module** is available in your PowerShell session.

---
