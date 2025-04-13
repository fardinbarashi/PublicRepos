<!-- ABOUT THE PROJECT -->
## About The Project
# GetMemberFromM365DynamicsGroup

## 🔧 System Requirements

- **PowerShell version**: 7+
- **Microsoft Graph PowerShell SDK**

---

## 📄 About the Script

**Author**: Fardin Barashi  
**Title**: `GetMemberFromM365DynamicsGroup`  
**Version**: 1.0  
**Release Date**: 2025-04-13  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## ✨ Description

This script connects to **Microsoft Graph** using a **certificate-based App Registration**, and exports all members of a specified **Entra ID (Azure AD) group** to a CSV file.

### 🔍 Features

- Retrieves **all users** from a group (handles **pagination** for large groups).
- Collects user attributes:
  - Name, email, mobile, business phone, department, location, etc.
- Attempts to fetch and include the **user's manager name**.
- Handles:
  - Empty values → `null`
  - Missing attributes → `FieldIsMissing<Attribute>`
- Outputs:
  - A full **CSV** of all group members
  - A **log file** of any failed user lookups

---

<!-- GETTING STARTED -->
## ⚙️ Configuration
Change in row 65
Change value 6000 in row to higher if you got more then 6000 users in group. $response = Get-MgGroupMember -GroupId $groupId -Top 6000
Add app-id settings files\MsGraph\MsGraphSettings.json
Example content:
```json
{
  "AppId": "<your-app-id>",
  "TenantId": "<your-tenant-id>",
  "CertificateThumbprint": "<your-cert-thumbprint>"
}
```



<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Linkedin - [Fardin Barashi]([https://twitter.com/your_username](https://www.linkedin.com/in/fardin-barashi-a56310a2/)) - email@example.com

<p align="right">(<a href="#readme-top">back to top</a>)</p>






