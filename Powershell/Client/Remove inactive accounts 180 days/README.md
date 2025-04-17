# Inactive User Profile Cleanup Script (PowerShell)

## 🧹 Overview
This PowerShell script helps you automatically clean up old, inactive user profiles on a Windows machine. It detects accounts that haven't logged in for more than 180 days (or a custom value you define) and removes their local profile data from the system.

---

## ✅ Features
- 🕒 Detects inactive accounts based on last login time
- 🧼 Removes user profile data including registry entries and home folders
- 🔧 Customizable inactivity threshold (default: 180 days)
- ⚙️ Works silently in the background using WMI and CIM

---

## 💻 System Requirements

- **OS:** Windows 10 Enterprise  
- **Build:** 17763 or higher  
- **PowerShell Version:** 5.1+  
- **Administrator privileges** required to remove user profiles

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>


---

## 🛠️ Usage

1. **Clone or download the script to your machine.**
2. **Open PowerShell as Administrator**.
3. **Adjust inactivity period (optional):**  
   By default, the script deletes accounts inactive for **180 days**.  
   To change that, update the following line:
   ```powershell
   $DaysFilterAccounts = (Get-Date).AddDays(-180)
   ```
   For example, to set it to 90 days:
   ```powershell
   $DaysFilterAccounts = (Get-Date).AddDays(-90)
   ```

4. **Run the script.**  
   It will search for inactive user profiles that are not currently loaded or special accounts, and remove them if eligible.

---

## 🔍 What It Does

- Queries user profiles via `Win32_UserProfile`
- Filters out profiles that are:
  - Not currently loaded
  - Not special accounts (like system)
  - Have a `LastUseTime` older than the specified threshold
- Deletes matching profiles using `Remove-WmiObject`

---

## 📓 Notes

- **Version:** 1.0  
- **Author:** [Fardin Barashi](mailto:Fardin.Barashi@gmail.com)  
- **Created:** 2019-07-05  

---

## ⚠️ Warning
⚠️ This script **permanently removes** local user profiles. Make sure you understand which profiles will be deleted before running in a production environment. Always test in a safe environment first.

---

## 🧪 Example

```plaintext
[User profile older than 180 days detected]
Removing profile: C:\Users\olduser1
Removing profile: C:\Users\olduser2
...
```

If no inactive accounts are found:

```plaintext
No inactive accounts found
```

---

## 📁 Related Registry Paths Removed
- `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\<SID>`
- `C:\Users\<Username>` (home folder)

---

