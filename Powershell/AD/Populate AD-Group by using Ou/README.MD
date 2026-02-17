# AD-User Password Expiry Report

![PowerShell](https://img.shields.io/badge/PowerShell-5.1-blue?logo=powershell)
![Active Directory](https://img.shields.io/badge/Module-ActiveDirectory-green)
![Version](https://img.shields.io/badge/Version-1.0-orange)
![Release](https://img.shields.io/badge/Release-2026--02--17-lightgrey)

## About

This script queries an Active Directory group and identifies users with password or account expiry issues. It covers three scenarios: passwords that have already expired, accounts that have already expired, and passwords that are about to expire within a configurable number of days.

**Author:** Fardin Barashi  
**Version:** 1.0  
**Release Date:** 2026-02-17  
**GitHub:** [fardinbarashi](https://github.com/fardinbarashi)

---

## Features

- Recursively scans all members of a specified AD group
- Detects users whose **password has already expired**
- Detects users whose **account has expired or is disabled**
- Detects users whose **password will expire within a defined number of days**
- Full transcript logging with timestamps
- Try/Catch error handling in each section

---

## Requirements

| Requirement | Value |
|---|---|
| PowerShell Version | 5.1 |
| PS Edition | Desktop |
| .NET CLR Version | 4.0.30319.42000 |
| Required Module | ActiveDirectory |

---

## Configuration

Before running the script, set the following variables:

| Variable | Description | Example |
|---|---|---|
| `$AdGroup` | The name of the AD group to scan | `"Domain Users"` |
| `$PasswordValueDays` | Number of days ahead to check for expiring passwords | `14` |

---

## Folder Structure

```
📁 Script Root
├── 📄 AD-User-PasswordExpiry.ps1
└── 📁 Logs/
    └── AD-User-PasswordExpiry.ps1 - yyyy/MM/dd/HH.mm.ss.Txt
```

> Make sure the `Logs` folder exists before running the script.

---

## How It Works

The script is divided into three sections:

**Section 1 – Password Already Expired**  
Retrieves all enabled users in the AD group whose `PasswordExpired` flag is set to `true`. Returns properties including `SamAccountName`, `Name`, `givenName`, `sn`, `Enabled`, `PasswordExpired`, `MemberOf`, and the computed password expiry time.

**Section 2 – Account Has Expired**  
Retrieves all users in the AD group whose account has already expired or is disabled. A calculated property `WillExpire` is added by converting the `AccountExpires` value to a DateTime and comparing it against the current date. Users with `AccountExpires` set to the maximum value (`9223372036854775807`, meaning "never") are excluded.

**Section 3 – Password About to Expire**  
Retrieves all enabled users who can change their password, whose password is not set to never expire, and whose password has not yet expired — but will expire within the number of days defined by `$PasswordValueDays`. Results are sorted by expiry date. A calculated `ExpiryDate` and `WillExpire` flag are added using `msDS-UserPasswordExpiryTimeComputed`.

---

## Returned Properties

### Section 1 – Password Expired

| Property | Description |
|---|---|
| SamAccountName | User logon name |
| Name | Full name |
| givenName | First name |
| sn | Last name |
| Enabled | Whether the account is enabled |
| PasswordExpired | Whether the password has expired |
| MemberOf | Group memberships |
| msDS-UserPasswordExpiryTimeComputed | Computed password expiry date |

### Section 2 – Account Expired

| Property | Description |
|---|---|
| SamAccountName | User logon name |
| Name | Full name |
| givenName | First name |
| sn | Last name |
| Enabled | Whether the account is enabled |
| AccountExpires | Raw account expiry value |
| PasswordNeverExpires | Whether the password is set to never expire |
| WillExpire | Calculated — `true` if account has already expired |

### Section 3 – Password About to Expire

| Property | Description |
|---|---|
| givenName | First name |
| sn | Last name |
| SamAccountName | User logon name |
| PasswordLastSet | Date the password was last changed |
| MemberOf | Group memberships |
| LastLogonDate | Calculated from `LastLogonTimestamp` |
| ExpiryDate | Calculated from `msDS-UserPasswordExpiryTimeComputed` |
| WillExpire | Calculated — `true` if expiry is within `$PasswordValueDays` |

---

## Usage

```powershell
# Set variables before running
$AdGroup = "YourGroupName"
$PasswordValueDays = 14

.\AD-User-PasswordExpiry.ps1
```

---

## Error Handling

Each section uses `Try/Catch`. If an error occurs, the script will:
1. Print the error message in red
2. Display the PowerShell error details
3. Stop the transcript
4. Exit the script

---

## Notes

- The script requires read permissions on the AD group and its members.
- `$AdGroup` must be defined before the script runs — it is currently not set inside the script.
- Section 1 does not store its results in a variable — consider assigning the output to `$GetUsersPasswordExpired` if you plan to use the data downstream (e.g., for reporting or email).
- There is a typo in the Section 1 label (`GGet` instead of `Get`) — this does not affect functionality but can be cleaned up.
