# 🔐 Check Logins on Server

This PowerShell script extracts and logs all **successful interactive logins (Event ID 4624)** from the local server over a specified time range (default: last 35 days). It is designed for audit purposes and supports CSV export with detailed login metadata.

---

## 🚀 Features

- 📆 Filters **Event ID 4624** over the last *n* days (default: 35)
- 🧠 Filters out non-user accounts like **NT AUTHORITY** and **Window Manager**
- ✅ Only includes interactive logins (`LogonType = 2 or 11`)
- 💾 Exports results to a timestamped `.csv` file per host
- 🗂️ Output includes detailed login metadata (User, Domain, IP, Process, etc.)
- 📝 Transcript logging enabled for auditing and debugging

---

## 🧰 System Requirements

| Requirement         | Details                    |
|---------------------|----------------------------|
| PowerShell Version  | 5.1 or higher              |
| Execution Policy    | Must allow script execution (`RemoteSigned` or `Unrestricted`) |
| Permissions         | Admin rights to access Security log |
| Log Retention       | Security log must contain data going back at least the requested number of days |
| CSV Output Folder   | Must exist and be writeable |

Each row in the exported CSV contains:
ComputerName
TimeCreated
EventId
SubjectUserSid
SubjectUserName
SubjectDomainName
TargetUserSid
TargetUserName
TargetDomainName
LogonType
LogonProcessName
IpAddress
---

## ⚙️ Configuration

| Variable         | Description                                       |
|------------------|---------------------------------------------------|
| `$DateFilter`    | Number of days to look back (default: 35)         |
| `$XPath`         | XPath string to filter event log (not used directly) |
| `$CsPath`        | Output path for the resulting `.csv` file         |
| `$TranscriptLog` | Path for storing the PowerShell session transcript |

All settings are defined inline at the top of the script.

---

## 📘 Example Scenario

You want to extract all successful interactive user logins from the last 35 days on a single Windows server and save them as a CSV for auditing:

```powershell
$DateFilter = (Get-Date).AddDays(-35)
```


## 📂 Output

- Transcript logs saved in:
  ```
  \Logs\<ScriptName> - <timestamp>.txt
  ```
- Csvfiles saved in:
  ``` "$PSScriptRoot\" 
  Files\Report\Csv\logon events OnServer; $($env:COMPUTERNAME) $($LogFileDate).csv
  ```
---

## 🧑‍💻 Author

- **Name:** Fardin Barashi  
- **Version:** 1.0  
- **Release Date:** 2025-07-07  
- **GitHub:** [github.com/fardinbarashi](https://github.com/fardinbarashi)

---



<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.





