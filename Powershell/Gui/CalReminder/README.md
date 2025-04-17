# Cal-Reminder

## 📅 Overview
**Cal-Reminder** is a PowerShell script designed to help system administrators track expiring objects (such as certificates or other assets) using a CSV file. If any object is set to expire within a specified number of days (default: 15), the script sends an email notification with the expiring objects attached as a `.txt` file.

---

## ✅ Features

- 🔎 Scans a CSV file for objects with expiration dates
- 📬 Sends email alerts when objects are about to expire
- 📎 Includes a detailed `.txt` attachment of expiring items
- 🚫 Prevents duplicate alerts by removing stale alert files
- 🧾 Simple structure and easy configuration

---

## 💻 System Requirements

- **PowerShell Version:** 5.1.19041.2364  
- **SMTP Relay:** Required (customize `$SmtpServer`)  

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

---

## 🗂️ CSV File Format

The script uses a file named `Calenderdates.csv` located at:

```
C:\Temp\CalReminder\csvfile\Calenderdates.csv
```

### 📋 Required Columns:

| Column       | Description                                                                 |
|--------------|-----------------------------------------------------------------------------|
| `Enddate`    | The expiration date in **MM-DD-YYYY** format (e.g., `12-30-2025`)          |
| `ObjectName` | Name of the expiring object (e.g., certificate name)                       |
| `Template`   | Template or type (e.g., Web Server Certificate)                            |
| `Server`     | Server name or host                                                        |
| `Enviroment` | Environment (e.g., Test, Development, Live)                                |
| `Description`| Short description of the object                                            |

---

## 📦 Output

If expiring objects are found, a file called `ExpiredObject.txt` will be generated at:

```
C:\Temp\CalReminder\ExpiredObject\ExpiredObject.txt
```

This file is then attached to the email sent to the configured recipient.

---

## ✉️ Email Configuration

Modify these variables at the top of the script to match your environment:

```powershell
$SmtpServer = "SmtpRelay.lab.local"
$MailFrom = "CalenderReminder@lab.local"
$MailTo = "ServiceMailbox <ServiceMailbox@lab.local>"
```

You may also update `$DaysTrigger` to change the number of days before expiration:

```powershell
$DaysTrigger = "15"
```

---

## 📧 Example Notification

**Subject:** `Cal-Reminder notification`  
**Body:**

> Objects are approaching 15 days before they become invalid.  
> See ExpiredObject.txt for more information.  
> Don’t forget to update the CSV file at `C:\Temp\CalReminder\csvfile\Calenderdates.csv`.

---

## ⚠️ Error Handling

- If `ExpiredObject.txt` from a previous run still exists, the script deletes it and sends an error notification.
- If the CSV file fails to import, a different error email is sent, alerting the administrator.

---

## 📓 Script Metadata

- **Author:** Fardin Barashi  
- **Title:** Cal-Reminder  
- **Version:** 1.0  
- **Release Date:** Not specified  
- **GitHub:** [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## 🔐 Permissions

- Requires permission to access local file paths for reading/writing
- SMTP server must allow relay from the machine running the script

---







