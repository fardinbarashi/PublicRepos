# PsGuiRolf

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>



# PsGuiRolf (PowerShell GUI)
## 🧼 Overview
**PsGuiRolf** is a graphical PowerShell application for managing user profiles on remote Windows machines. With an intuitive interface and WMI backend, it enables IT admins to scan, view, and delete local profiles from multiple machines across the network. 
This tool is especially useful in environments with roaming users or shared computers, helping to free up disk space and clean inactive sessions.

---

## ✅ Features

- 🖥️ **Remote Profile Scanning**: Query any domain-joined or reachable Windows device for local user profiles.
- 📄 **Profile Metadata**: View `Path`, `SID`, `Last Login`, and `Login Status` for each profile.
- 🗑️ **Profile Deletion**: Right-click to delete one or multiple profiles from a remote system using WMI.
- 🔁 **Remote Reboot**: Reboot target machines directly from the UI.
- 🚫 **Log Off All Users**: Remotely log off all currently loaded sessions.
- 📶 **Ping & Connectivity Check**: Ensure the target machine is reachable before taking action.
- 🧾 **Transcript Logging**: All actions are recorded via PowerShell’s built-in `Start-Transcript`.

---

## 💻 System Requirements

| Requirement            | Version                  |
|------------------------|--------------------------|
| PowerShell Version     | 5.1.19041.2364 or higher |
| .NET CLR Version       | 4.0.30319.42000          |
| OS Compatibility       | Windows 7 and above      |
| Admin Rights           | Required for WMI actions |
| Network Access         | WMI ports (DCOM) open    |

---

## 🧭 How to Use

1. **Run as Administrator** for proper WMI permissions.
2. Enter the **computer name** of the remote machine.
3. Click **Search** to scan for all local profiles.
4. Review profile info in the **ListView**.
5. Right-click any `SID` row to **delete** the profile.
6. Optional:
   - Use the top menu to **Reboot**, **Log Off Users**, or **Ping** the remote machine.

---

## 📂 File Structure

| Path                                            | Purpose                                      |
|-------------------------------------------------|----------------------------------------------|
| `ListViewColumn.xml`                            | XML definition for ListView column headers   |
| `Data\Database\Csv\UserAttributes.csv`          | Temp DB of profile attributes                |
| `Data\Img\Logo\Logo.ico`                        | App icon                                     |
| `Logs\*.txt`                                    | Transcript log for each session              |

---

## 📝 Script Metadata

- **Author:** [Fardin Barashi](mailto:Fardin.Barashi@gmail.com)  
- **Initial Release:** March 3, 2018  
- **Last Update:** March 5, 2018  
- **Version:** 1.02  
- **GitHub Repository:** [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

### 🔄 Changelog
- **v1.0** – Initial build: scan and delete local profiles.
- **v1.02** – Added ability to open `\\hostname\C$\Users` from the GUI.

---

## 🔐 Permissions

To fully function, PsGuiRolf requires:
- Local or domain admin rights
- WMI access to remote machines
- Permission to delete user profiles

---

## 🚨 Disclaimer

This tool **permanently deletes** user profile data from remote systems. Use with caution and only in environments where you are authorized to manage remote machines.

---

## 📸 Example Use Case

**Target Machine:** `PC-Lab-01`  
**Profiles Found:**

| Path                      | Last Login       | Logged In | SID                                    |
|---------------------------|------------------|-----------|-----------------------------------------|
| C:\Users\TestUser         | 2023-10-12 13:12 | False     | S-1-5-21-1122334455-...                 |
| C:\Users\OldAdmin         | 2022-08-03 07:32 | False     | S-1-5-21-9988776655-...                 |

Right-click on `SID` → **Delete Profile**.

---

## 💬 Status Panel & Feedback

All operations update a live **status bar** at the bottom of the UI. Errors, confirmations, and task progress are displayed in real time.

---

