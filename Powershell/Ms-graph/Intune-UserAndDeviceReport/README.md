# AzureAD & Intune -  User and Device Export Script
# ☁️ Azure AD User and Device Export Script

## 🔍 Overview

This PowerShell script retrieves user and device information from **Azure Active Directory (Azure AD)** and **Microsoft Intune**, using **Microsoft Graph API**. The data is combined and exported to a CSV file for reporting or further analysis.

---

## ✅ Features

- 🔐 Authenticates securely via **Microsoft Graph** with **client credentials**
- 📥 Retrieves:
  - User Display Name
  - User Principal Name
  - Office Location
  - Device Names
  - User IDs
- 💾 Combines user and device info into a single **CSV export**
- 🧪 Uses pagination to handle large datasets
- 📝 Logs all activity in a timestamped transcript file

---

## 📦 Requirements

| Requirement             | Value                                      |
|-------------------------|--------------------------------------------|
| PowerShell Version      | 5.1 or higher                              |
| Modules Required        | None (uses `Invoke-RestMethod`)            |
| API Permissions         | `User.Read.All`, `Directory.Read.All`, `DeviceManagementManagedDevices.Read.All` |
| Azure App Registration  | Must use **client credentials flow**       |
| Authentication Method   | `client_id`, `client_secret`, `tenant_id`  |

---

## 🔐 Microsoft Graph Setup

Ensure you have the following **permissions assigned** to your app in Azure:

> **Azure Portal → App registrations → Your App → API permissions → Microsoft Graph → Application permissions**

Recommended:
- `User.Read.All`
- `Directory.Read.All`
- `DeviceManagementManagedDevices.Read.All`

Don't forget to **grant admin consent**.

---

## ⚙️ Configuration

Inside the script, set your app details:

```powershell
$client_id     = "<your-client-id>"
$client_secret = "<your-client-secret>"
$tenant_id     = "<your-tenant-id>"
```

---

## 🧾 Output Example

The exported CSV will look like this:

| displayName     | userPrincipalName     | userId     | deviceName           | officeLocation |
|------------------|------------------------|------------|-----------------------|----------------|
| Jane Doe         | jane.doe@domain.com    | 12345678   | LAPTOP-12345          | Stockholm      |
| John Smith       | john.smith@domain.com  | 23456789   | SURFACEPRO-87654      | Göteborg       |

---

## 📁 File Outputs

| File                                      | Description                         |
|-------------------------------------------|-------------------------------------|
| `Files/<ScriptName> - yyyy-MM-dd.csv`     | Combined CSV with user-device data  |
| `Logs/<ScriptName> - yyyy/MM/dd/HH.mm.ss.Txt` | Transcript log of the script run     |

---

## 🧠 Script Logic

1. **Authenticate**
   - Uses `client_credentials` grant type
   - Fetches a bearer token from Microsoft

2. **Fetch Users**
   - Uses `https://graph.microsoft.com/v1.0/users`
   - Handles pagination with `@odata.nextLink`

3. **Fetch Devices**
   - Uses `https://graph.microsoft.com/v1.0/deviceManagement/managedDevices`
   - Matches devices with users by `userId`

4. **Combine + Export**
   - Matches user-device pairs
   - Exports to CSV
   - Logs execution

---

## ❗ Error Handling

If token request or API calls fail, the script will:
- Display detailed error messages
- Show response bodies if available
- Log the issue in the transcript
- Exit gracefully

---

## 📓 Metadata

| Property         | Value                                          |
|------------------|------------------------------------------------|
| **Author**       | Fardin Barashi                                 |
| **Script Title** | Azure AD User and Device Export Script         |
| **Version**      | 1.0                                            |
| **Release Date** | 2023-05-11                                     |
| **GitHub**       | [github.com/fardinbarashi](https://github.com/fardinbarashi) |

---


<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.


