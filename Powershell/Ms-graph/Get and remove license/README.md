# 🧾 Get and Remove Microsoft 365 License via MS Graph API

## 📄 Description

This PowerShell script connects securely to Microsoft Graph using a **registered app with certificate authentication**, retrieves license details for a specified user, and **removes all assigned licenses** for that user from the tenant.

---

## ⚙️ Features

- 🔐 Connects to Graph API using AppId, TenantId, and Certificate Thumbprint
- 👤 Fetches full license list from tenant via `Get-MgSubscribedSku`
- 🔍 Gets assigned licenses for a specific UPN (user principal name)
- ❌ Removes all assigned licenses from the user using `Set-MgUserLicense`
- 🧾 Full script logging with `Start-Transcript`
- ✉️ Optional error mail alert via Microsoft Graph Mail (SMTP-less)

---

## 📌 System Requirements

| Requirement             | Version/Details                           |
|--------------------------|-------------------------------------------|
| PowerShell Version       | 5.1.19041.2364                            |
| Graph PowerShell SDK     | `Microsoft.Graph` modules                |
| Permissions (API)        | `User.Read.All`, `Directory.ReadWrite.All`, `Organization.Read.All`, `Mail.Send` (optional) |
| Auth Type                | Certificate-based App Registration       |

---

## 📂 Input Parameters

```powershell
-param(
    [Parameter(Mandatory=$True)][string]$upn
)
```

- `upn`: The user's UPN (email) to target for license removal.

---

## 🔐 Setup Requirements

Before running the script, make sure:

1. ✅ Your **Azure AD App** is registered
2. 🔐 A **certificate** is generated and uploaded to the app
3. 📜 You've **granted admin consent** for required Graph API permissions
4. 💬 Replace the following in the script:
   - `$AppId = "your-app-id"`
   - `$TenantId = "your-tenant-id"`
   - `$CertificateThumbprint = "your-cert-thumbprint"`

---

## 🛠️ Script Workflow

1. Start transcript and logging
2. Connect to Microsoft Graph using certificate-based authentication
3. Fetch the user with `Get-MgUser`
4. Get all tenant licenses with `Get-MgSubscribedSku`
5. Get the user's assigned licenses
6. If licenses are present, remove all using `Set-MgUserLicense`
7. Errors? Sends optional email via Graph with `Send-MgUserMail`

---

## 📁 Output

- License removal results shown in console
- Full transcript saved to:
  ```
  /Logs/<ScriptName> - <timestamp>.txt
  ```

---

## ✉️ Optional: Email Alerts

The script includes a built-in function `Function-Send-Mail-MsGraph` that can notify admins if license removal fails.

> 📬 Requires valid Graph Mail permissions and sender/recipient values set:
```powershell
$To = "admin@domain.com"
$From = "graph-mail-user@domain.com"
```

---

## 🚀 Example Usage

```powershell
.\Remove-License.ps1 -upn "john.doe@contoso.com"
```

---

## 🧑‍💻 Author

- **Name:** Fardin Barashi  
- **Version:** 1.0  
- **Release Date:** 2025-03-24  
- **GitHub:** [github.com/fardinbarashi](https://github.com/fardinbarashi)

---

<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
