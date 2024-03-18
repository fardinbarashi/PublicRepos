# AzureAD & Intune -  User and Device Export Script

<!-- ABOUT THE PROJECT -->
## About The Project
This PowerShell script is designed to extract user and device information from Azure Active Directory (Azure AD) and Microsoft Intune through Microsoft Graph API, and then export it to a CSV file. The information includes user display names, user principal names, office locations, user Ids, and device names. The script requires PowerShell 5.1 or higher.


<!-- GETTING STARTED -->
## Getting Started
Before you run this script, you need to create an app registration in Azure AD:
1. Go to the [Azure portal](https://portal.azure.com).
2. Navigate to Azure Active Directory > App Registrations > New Registration.
3. Fill out the form with your app's details.
4. After the app is registered, you'll be redirected to your app's "Overview" page. Here, you can find your `client_id` (Application ID).
5. Next, create a client secret by going to "Certificates & secrets" > "New client secret". Copy the `client_secret` value immediately and securely. It won't be shown again.
6. Assign API permissions to the app by going to "API permissions" > "Add a permission" > "Microsoft Graph" > "Application permissions". Add the necessary permissions (like `User.Read.All`, `DeviceManagementManagedDevices.Read.All`, `Directory.Read.All`) depending on your requirements.
7. Click on "Grant admin consent for [your tenant]" to grant the permissions.
8. The `tenant_id` can be found in Azure Active Directory > Properties > Directory ID.
9. You can now use the `client_id`, `client_secret`, and `tenant_id` to run the script.



<!-- LICENSE -->
## License
Distributed under the GPL-3.0 License. See `LICENSE.txt` for more information.
<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- CONTACT -->
## Contact

Linkedin - [Fardin Barashi]([https://twitter.com/your_username](https://www.linkedin.com/in/fardin-barashi-a56310a2/)) - email@example.com

<p align="right">(<a href="#readme-top">back to top</a>)</p>

