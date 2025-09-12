<!-- ABOUT THE PROJECT -->
## About The Project
# createupdateAuthenticaphone

## System Requirements

- **PowerShell version**: 7+
- **Microsoft Graph PowerShell SDK**

---

## About the Script

**Author**: Fardin Barashi  
**Title**: `createupdateAuthenticaphone`  
**Version**: 1.0  
**Release Date**: 2025-09-12  
**GitHub**: [https://github.com/fardinbarashi](https://github.com/fardinbarashi)

---

## Description

This script connects to **Microsoft Graph** using a **certificate-based App Registration**, and This script loads the csv, and inserts the mobilnumber to user Authenticaphone value, 
if method is missing it will create the method.
Script is using an app-reg with access to API**

### Features
- Adds Mobilenumber to Authenticaphone
- Created phone as method if it is missing
- Outputs:
  - A CSV of all the users that has been processed


---

<!-- GETTING STARTED -->
## Configuration
Change in row 65
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

<!-- MS-Links -->
## MS-Links
{
Get-MgUserAuthenticationPhoneMethod ( https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.identity.signins/get-mguserauthenticationphonemethod?view=graph-powershell-1.0 )

Update-MgUserAuthenticationPhone ( https://learn.microsoft.com/en-us/powershell/module/microsoft.graph.identity.signins/update-mguserauthenticationphonemethod?view=graph-powershell-1.0 )
}

 


<!-- CONTACT -->
## Contact
Linkedin - [Fardin Barashi](https://www.linkedin.com/in/fardin-barashi-a56310a2/)







