# Microsoft 365 Endpoints

<!-- ABOUT THE PROJECT -->
<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.


# 🌐 Microsoft 365 Endpoints Checker

## 🔍 Overview

This PowerShell script connects to the official [Microsoft 365 endpoints web service](https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide) and retrieves the **Optimize**, **Allow**, and **Default** endpoint categories. The result includes IP addresses and URLs that Microsoft 365 services depend on and saves them to separate `.txt` files for firewall/traffic control planning.

> The script utilizes the newer **REST-based service**, which has replaced downloadable XML files (deprecated in 2018).

---

## ✅ Features

- 📡 Connects to: `https://endpoints.office.com`
- 🔄 Uses a dynamic **`clientRequestId`** for every session
- ✅ Retrieves and filters:
  - Optimize IPs (used for performance-critical traffic)
  - Allow IPs (needed for essential services)
  - Default URLs (used for non-critical services)
- 💾 Saves raw and filtered output as `.txt` files
- 🧾 Full logging using `Start-Transcript`

---

## 🛠️ Requirements

| Requirement             | Value                                |
|-------------------------|--------------------------------------|
| PowerShell Version      | 5.x                                  |
| Internet Access         | Required                             |
| No external modules     | Needed – Pure PowerShell             |
| Endpoint Docs           | [Microsoft Docs](http://aka.ms/ipurlws) |

---

## 📁 Output Files

All files are saved in the `Files` directory under your script's root:

| File Name Format                                   | Description                                   |
|----------------------------------------------------|-----------------------------------------------|
| `Microsoft Optimize Endpoints data <timestamp>.txt` | Raw Optimize endpoint data                    |
| `Microsoft Optimize Endpoints <timestamp>.txt`      | Filtered IPv4 Optimize addresses              |
| `Microsoft Allow Endpoints data <timestamp>.txt`    | Raw Allow endpoint data                       |
| `Microsoft Allow Endpoints IPv4 <timestamp>.txt`    | Filtered IPv4 Allow addresses                 |
| `Microsoft Default data Endpoints <timestamp>.txt`  | Raw Default endpoint data                     |
| `Microsoft Default Endpoints <timestamp>.txt`       | Filtered Default service URLs                 |
| `Logs/<ScriptName> - <timestamp>.txt`               | Full execution log from Start-Transcript      |

---

## ⚙️ Script Flow

1. 🔁 **Generate a GUID** for API session
2. 🌐 **Connect** to Microsoft’s endpoint service
3. 📥 **Retrieve and filter data** by:
   - `category = "Optimize"`
   - `category = "Allow"`
   - `category = "Default"`
4. ✍️ **Output the results** to `.txt` files
5. 🛑 If any section fails, the script logs and exits cleanly

---

## 💬 Output Preview

Example of Optimize IPv4 data:

```
40.96.0.0/13
52.96.0.0/14
13.107.128.0/22
...
```

Example of Default URLs:

```
portal.office.com
outlook.office365.com
teams.microsoft.com
...
```

---

## 📓 Script Metadata

| Property         | Value                                                 |
|------------------|-------------------------------------------------------|
| **Author**       | Fardin Barashi                                        |
| **Script Title** | Microsoft 365 Endpoints Checker                       |
| **Version**      | 1.0                                                   |
| **Release Date** | 2023-12-20                                            |
| **GitHub**       | [github.com/fardinbarashi](https://github.com/fardinbarashi) |
| **Docs**         | [Microsoft Docs → IP/URL Ranges](http://aka.ms/ipurlws) |

---

## 🔐 Use Case

- 🧱 Network/firewall planning
- 🚦 Traffic routing & prioritization
- 🌍 Proxy bypass configuration
- 📁 Export for audit/compliance

---

**– Built for IT admins, by an IT admin.**  
Keep your Microsoft 365 access fast and reliable.  

**☁️ PowerShell 5.x Ready – No external dependencies**

```powershell
Start-Process .\Check-M365-Endpoints.ps1 -Verb RunAs
```

