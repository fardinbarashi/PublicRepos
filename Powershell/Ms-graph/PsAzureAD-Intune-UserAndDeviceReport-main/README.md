#  PsAzureAD-Intune-UserAndDeviceReport
A quick report script that takes out Azure AD User and Device

# Azure AD User and Device Export Script

## Author
Fardin Barashi

## Description
This PowerShell script is designed to extract user and device information from Azure Active Directory (Azure AD) and Microsoft Intune through Microsoft Graph API, and then export it to a CSV file. The information includes user display names, user principal names, office locations, user Ids, and device names. The script requires PowerShell 5.1 or higher.

## Version
1.0

## Release day
2023-05-11

## Github Link
[GitHub Repository](https://github.com/fardinbarashi)

## System Requirements
- PSVersion: 5.1.19041.2364
- PSEdition: Desktop
- BuildVersion: 10.0.19041.2364
- CLRVersion: 4.0.30319.42000
- WSManStackVersion: 3.0
- PSRemotingProtocolVersion: 2.3
- SerializationVersion: 1.1.0.1

## Script Flow
1. **Transcript Settings and Authentication**: The script begins by setting up a transcript for logging purposes. It then authenticates with Azure AD using client credentials (client ID, client secret, and tenant ID) to obtain an access token.
2. **Calling Microsoft Graph API**: With the access token, the script makes two separate calls to the Graph API. The first call fetches user data from Azure AD, and the second call fetches device data from Microsoft Intune. The script collects all pages of data from the API by following the '@odata.nextLink' until there are no more pages of data.
3. **Combining User and Device Data**: After fetching the user and device data, the script maps the devices to their corresponding users using their unique identifiers (`userId` for devices and `id` for users).
4. **Export to CSV**: The script then creates a custom PowerShell object for each user-device pair and adds it to a results array. Each object contains selected properties from both the user and the device. The results are then exported to a CSV file.

## Error Handling
The script includes error handling logic to catch any exceptions that might occur during the API calls or while processing the data. Errors will be logged and script execution will be halted.

## Creating the App in Azure AD App Registration
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
