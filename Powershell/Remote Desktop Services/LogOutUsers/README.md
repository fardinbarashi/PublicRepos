# LogOutUsers

## 📄 Description

This PowerShell script **automatically logs off all active RDP (Remote Desktop Protocol) user sessions** on a host after displaying a warning message. It is intended to be used as part of a **daily maintenance routine** on Windows Servers.

---

## ⚙️ Features

- 🔍 Lists all current RDP sessions using `Get-RDUserSession`
- 💬 Sends warning message to each session: "You will be logged out in 2 minutes..."
- ⏳ Waits for 120 seconds (2 minutes)
- ❌ Forcefully logs off all listed RDP sessions
- 🧾 Transcript logging for auditing purposes

---

## 📌 System Requirements

| Requirement             | Version/Details                       |
|--------------------------|---------------------------------------|
| PowerShell Version       | 5.1.19041.2364                        |
| Module Dependency        | `RemoteDesktop` (e.g. `Get-RDUserSession`, `Invoke-RDUserLogoff`) |
| Privileges               | Must be run as **Administrator**     |

---

## 📂 Output

- Transcript log saved at:
  ```
  /Logs/<ScriptName> - <timestamp>.txt
  ```

---

## 🚦 Script Logic

1. **Start transcript**
2. **List all active RDP sessions**
3. **Send message** to all users (via `msg`) informing them of the upcoming logoff
4. **Wait 2 minutes** (`Start-Sleep`)
5. **Log off** all sessions using `Invoke-RDUserLogoff`

---

## 🛡️ Security Note

- This script must be run on servers with **Remote Desktop Services** installed.
- Ensure the account running the script has permissions to log off sessions.

---

## ⚠️ Example Warning Sent to Users

```text
You will be logged out in 2 min [timestamp] according to daily routine
```

---

## 🧑‍💻 Author

- **Name:** Fardin Barashi  
- **Version:** 1.0  
- **Release Date:** 2024-09-17  
- **GitHub:** [github.com/fardinbarashi](https://github.com/fardinbarashi)

---

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.


