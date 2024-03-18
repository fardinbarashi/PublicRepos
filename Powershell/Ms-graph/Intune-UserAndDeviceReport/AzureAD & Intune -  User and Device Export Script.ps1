<#
System requirements
PSVersion                      5.1.19041.2364                                                                                                       
PSEdition                      Desktop                                                                                                              
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}                                                                                              
BuildVersion                   10.0.19041.2364                                                                                                      
CLRVersion                     4.0.30319.42000                                                                                                      
WSManStackVersion              3.0                                                                                                                  
PSRemotingProtocolVersion      2.3                                                                                                                  
SerializationVersion           1.1.0.1      
Assign API permissions to the app by going to "API permissions" > "Add a permission" > "Microsoft Graph" > "Application permissions". Add the necessary permissions (like User.Read.All, DeviceManagementManagedDevices.Read.All, Directory.Read.All) depending on your requirements.

About Script 
Author : Fardin Barashi
Title : Azure AD User and Device Export Script
Description : Description: This PowerShell script is designed to extract user and device information from Azure Active Directory (Azure AD) and Microsoft Intune through Microsoft Graph API, and then export it to a CSV file. The information includes user display names, user principal names, office locations, user Ids, and device names. The script requires PowerShell 5.1 or higher.
Version : 1.0
Release day : 2023-05-11
Github Link  : https://github.com/fardinbarashi
News : 

#>

#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Error-Settings
$ErrorActionPreference = 'Continue'

# FilePath Settings
$CsvFile = "$PSScriptRoot\Files\$ScriptName - $LogFileDate.Csv" 

# Parameters
$client_id = "" 
$client_secret = ""
$tenant_id = ""
$scope = "https://graph.microsoft.com/.default"

#----------------------------------- Start Script ------------------------------------------
# Section 1 : Get an access token
$Section = "Section 1 : Get an access token"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Get an access token
$body = @{
    client_id     = $client_id
    scope         = $scope
    client_secret = $client_secret
    grant_type    = "client_credentials"
}
$token = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenant_id/oauth2/v2.0/token" -Method POST -Body $body -Verbose

 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red

 Write-Warning "StatusCode:" $_.Exception.Response.StatusCode.value__
 Write-Warning "StatusDescription:" $_.Exception.Response.StatusDescription
 Write-Warning "Response:" $_.Exception.Response.GetResponseStream()
 Write-Warning $Error[0]

 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

# Section 2 : Call the Graph Api and export users
$Section = "Section 2 : Call the Graph Api and export users and devices"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Call the Graph API
 $headers = @{ Authorization = "Bearer $($token.access_token)" }
 
 # Fetch user data
 $usersUri = "https://graph.microsoft.com/v1.0/users"
 $users = @()

 # Fetch device data
 $devicesUri = "https://graph.microsoft.com/v1.0/deviceManagement/managedDevices"
 $devices = @()

 # Invoke - RestMethod
  do 
   { # Start Do for usersUri
     $response = Invoke-RestMethod -Uri $usersUri -Method GET -Headers $headers
     $users += $response.value
     $usersUri = $response.'@odata.nextLink'
   } # End Do for usersUri
   while ($usersUri)

  do
   { # Start Do devicesUri
     $response = Invoke-RestMethod -Uri $devicesUri -Method GET -Headers $headers
     $devices += $response.value
     $devicesUri = $response.'@odata.nextLink'
   } # End Do devicesUri
   while ($devicesUri)

 # Combine user and device data
 $results = @()
  foreach ($user in $users) 
   { # Start foreach ($user in $users) 
   $userDevices = $devices | Where-Object { # Start Where-Object 
     $_.userId -eq $user.id 
    } # End Where-Object 
     foreach ($device in $userDevices) 
      { # Start foreach ($device in $userDevices) 
        $results += New-Object PSObject -Property @{ # Start New-Objects
            displayName         = $user.displayName
            userPrincipalName   = $user.userPrincipalName
            officeLocation      = $user.officeLocation
            userId              = $device.userId
            DeviceName          = $device.deviceName
        } # End # Start New-Objects
    } # End foreach ($device in $userDevices) 
   } # End foreach ($user in $users) 

 # Export to CSV
 $results | 
 Select-Object displayName, UserPrincipalName, userId, DeviceName, officeLocation | 
 Export-Csv -Path $CsvFile -Encoding UTF8 -NoTypeInformation

Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning "StatusCode:" $_.Exception.Response.StatusCode.value__
 Write-Warning "StatusDescription:" $_.Exception.Response.StatusDescription
 $responseStream = $_.Exception.Response.GetResponseStream()
 $reader = New-Object System.IO.StreamReader($responseStream)
 $reader.BaseStream.Position = 0
 $reader.DiscardBufferedData()
 $responseBody = $reader.ReadToEnd();
 Write-Warning "Response:" $responseBody
 Write-Warning $Error[0]

 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch


#----------------------------------- End Script ------------------------------------------
Stop-Transcript
