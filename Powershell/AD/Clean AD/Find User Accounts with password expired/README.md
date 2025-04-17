<!-- ABOUT THE PROJECT -->
## About The Project
# Get Users with Password or Account Expiry in AD

## System Requirements

- **PowerShell version**: 5.1.19041.2364  


---

## About the Script

**Author**: Fardin Barashi  
**Title**: `Get Users with Password or Account Expiry in AD`  
**Version**: 1.0  
**Release Date**: 2023-01-31  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## Description

This PowerShell script fetches Active Directory users within a specified group that meet the following criteria:

1. **Users with expired passwords**
2. **Users whose accounts have expired**
3. **Users whose passwords are about to expire**

The script retrieves and filters key user attributes and supports further automation or export if needed.

### Features

- Query members of a given AD group recursively.
- Identify:
  - Enabled users with expired passwords.
  - Users with expired or disabled accounts (`AccountExpires` logic).
  - Users with passwords about to expire within X days.
- Selects key attributes such as:
  - `samAccountName`, `Name`, `Enabled`
  - `PasswordExpired`, `AccountExpires`, `PasswordLastSet`
  - `PasswordNeverExpires`, `LastLogonTimestamp`, `msDS-UserPasswordExpiryTimeComputed`
- Easy to modify for alerts, reports, or user notification scripts.

---

<!-- GETTING STARTED -->
## Configuration

1. **Set the target AD group**:  
   Replace the variable `$AdGroup` with the name of the group you want to query.

2. **Set password expiry threshold** (optional):  
   Set `$PasswordValueDays` to define what counts as "about to expire".

3. **Ensure required modules are available**:  
   - `ActiveDirectory` module must be imported and available in the PowerShell session.

4. **Permissions**:  
   Run the script with privileges to read user properties in Active Directory.

---

<!-- LICENSE -->
## License

Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.

---

<!-- CONTACT -->
## Contact

LinkedIn - [Fardin Barashi](https://www.linkedin.com/in/fardin-barashi-a56310a2/)
