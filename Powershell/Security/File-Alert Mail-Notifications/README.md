# File-Alert Mail-Notifications
## 📄 Description

This PowerShell script monitors a specified folder and **alerts via email if any files have not been moved** (i.e., created or modified) within a defined time window. Useful for monitoring drop folders, automated flows, or business-critical imports.

---

## ⚙️ Features

- 📦 Checks all files of a specific type (`*.xml` by default) in a given directory
- ⏳ Compares the file creation time against a user-defined `TimeSpan` (days, hours, minutes)
- 📬 Sends an alert **email per file** that hasn't been moved
- 🧾 Transcript logging enabled for full audit trail

---

## 📌 System Requirements

| Requirement             | Version/Details            |
|--------------------------|----------------------------|
| PowerShell Version       | 5.1.19041.2364             |
| SMTP Mail Enabled        | Yes                        |
| Run Mode                 | Local                      |
| Permissions              | Read access to target path |

---

## 🛠️ Configuration

| Setting         | Description                                    |
|----------------|------------------------------------------------|
| `$FilePath`     | Folder path to monitor                         |
| `$FileTypes`    | File types to include (e.g., `*.xml`, `*.csv`) |
| `$TimeSpanDays` | Days back to check file creation time          |
| `$TimeSpanHours`| Hours back to check                            |
| `$TimeSpanMins` | Minutes back to check                          |
| `$MailTo`       | Recipient email address                        |
| `$MailFrom`     | Sender email address                           |
| `$SmtpServer`   | SMTP server address                            |

---

## 💡 Example Scenario

You want to monitor `\\server\dropzone` for `.xml` files, and alert your operations team if any file has not moved in the past 30 minutes.

```powershell
$FilePath = "\\server\dropzone"
$FileTypes = "*.xml"
$TimeSpanDays = 0
$TimeSpanHours = 0
$TimeSpanMins = 30
$MailTo = "ops@company.com"
$MailFrom = "alert@company.com"
$SmtpServer = "smtp.company.com"
```

---

## 📨 Email Alert Example

Each file that matches the criteria triggers an individual email, like:

- **Subject:** `Type MailTitle`
- **Body:** `Type MailBody Text , Unc \\server\dropzone\file.xml`

> ✉️ Make sure your mail relay allows relaying from the script’s host.

---

## 📂 Output

- Transcript logs saved in:
  ```
  /Logs/<ScriptName> - <timestamp>.txt
  ```

---

## 🧑‍💻 Author

- **Name:** Fardin Barashi  
- **Version:** 1.0  
- **Release Date:** 2024-01-08  
- **GitHub:** [github.com/fardinbarashi](https://github.com/fardinbarashi)

---

> Keep your workflows running smooth and monitored. No more missed file transfers. 🔍📬




<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.





