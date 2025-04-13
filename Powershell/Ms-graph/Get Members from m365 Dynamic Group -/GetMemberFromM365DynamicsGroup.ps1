<#
System requirements
- PowerShell version: 7+
- Microsoft Graph PowerShell SDK                                                                                                

About Script :
Author : Fardin Barashi
Title : GetMemberFromM365DynamicsGroup
Description : 

.SYNOPSIS
This script connects to Microsoft Graph using a certificate-based App Registration and exports all members of a specified Entra ID (Azure AD) group to a CSV file.

.DESCRIPTION
- Retrieves all users from a specific group (including pagination for large groups).
- For each user, it collects detailed attributes like name, email, phone, department, etc.
- Attempts to fetch the user's manager and include the manager's name.
- Handles missing or empty attributes with "null" or "FieldIsMissing<Attribute>".
- Exports the final user list to a CSV file.

<!-- GETTING STARTED -->
Change in row 65
Change value 6000 in row to higher if you got more then 6000 users in group. $response = Get-MgGroupMember -GroupId $groupId -Top 6000
Add app-id settings files\MsGraph\MsGraphSettings.json
Example content:

{
  "AppId": "<your-app-id>",
  "TenantId": "<your-tenant-id>",
  "CertificateThumbprint": "<your-cert-thumbprint>"
}

Version : 1.0
Release day : 2025-04-13 
Github Link  : https://github.com/fardinbarashi
News : 

#>





#------------------------------- Settings -------------------------------

# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt"
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Load AssemblyName
Add-Type -AssemblyName System.Security

# Tenet-Settings
$Settings = Get-Content "$PSScriptRoot\files\MsGraph\MsGraphSettings.json" | ConvertFrom-Json
$AppId = $Settings.AppId
$TenantId = $Settings.TenantId
$CertificateThumbprint = $Settings.CertificateThumbprint
$Certificate = Get-ChildItem Cert:\LocalMachine\My\$CertificateThumbprint

# Get EntraID-Group
$groupId = "" # Group ID

# Error-Settings
$ErrorActionPreference = 'Continue'

# Modules to import
Import-Module Microsoft.Graph.Groups
Import-Module Microsoft.Graph.Users

#------------------------------- Functions -------------------------------
# Function Send-Mail-MsGraph when it catchs error
 Function Function-Send-Mail-MsGraph 
  { # Start Function-Send-Mail-MsGraph 
   $to = ""
   $from = ""
   $errorMailSubject = "PowershellError from machine $($env:COMPUTERNAME)))"
   $errorMailBodyText = @"
   Script $ScriptName on machine $($env:COMPUTERNAME)  $PSScriptRoot have failed.
   See the log and check the error message.
   The log file is located in $TranScriptLogFile
"@

  $mailBody = @{ # Start $mailBody 
   Message = @{
    Subject = $errorMailSubject
     Body = @{
      ContentType = "Text"
      Content = $errorMailBodyText }
     ToRecipients = @(
      @{ EmailAddress = @{ Address = $toFardin }}
       )
      }
     SaveToSentItems = $false
    } # End $mailBody 
    Send-MgUserMail -UserId $from -BodyParameter $mailBody
  }# End Start Function-Send-Mail-MsGraph  

# For the CSV If Attribute is missing data or is not valid
function Get-ValueOrFallback 
 { # Start function Get-ValueOrFallback 
  param (
  [Parameter(Mandatory = $true)][object]$InputObject,
  [Parameter(Mandatory = $true)][string]$PropertyName
  )
  if ($InputObject.PSObject.Properties.Name -contains $PropertyName) 
   { # Start if ($InputObject.PSObject.Properties.Name -contains $PropertyName) 
      # Value is missing data
      $value = $InputObject.$PropertyName
      if ($null -ne $value -and $value -ne "") 
      { # Start if ($null -ne $value -and $value -ne "") 
       return $value 
      } # End if ($null -ne $value -and $value -ne "") 
      else 
      { # Start Else, if ($null -ne $value -and $value -ne "") 
       return "null" 
      } # End Else, if ($null -ne $value -and $value -ne "") 
   } # End if ($InputObject.PSObject.Properties.Name -contains $PropertyName) 
   else 
   { # Start Else,if ($InputObject.PSObject.Properties.Name -contains $PropertyName) 
    # Field is missing in EntraID
    return "FieldIsMissing$PropertyName"
   } # End Else,if ($InputObject.PSObject.Properties.Name -contains $PropertyName) 
 } # End function Get-ValueOrFallback 
           
#------------------------------- Start Script -------------------------------

$Section = "Section 1 :"
Try 
 { # Start Try
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host $Section.. " 08" -ForegroundColor Yellow

    # Run Query
    Write-Host "Trying to connect to the MgGraph" -ForegroundColor Yellow
    $ConnectMgGraph = Connect-MgGraph -TenantId $TenantId -Certificate $Certificate -ClientId $AppId

    if ($ConnectMgGraph -eq $null) 
     { # Start if ($ConnectMgGraph -eq $null) 
        Get-Date -Format "yyyy/MM/dd HH:mm:ss"
        Write-Host "ERROR on $section" -ForegroundColor Red
        Write-Warning $Error[0]
        Write-Host "The Connections to MgGraph Failed, check your CertificateThumbprint" -ForegroundColor Yellow
        Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
        Stop-Transcript
        Exit
     } # End if ($ConnectMgGraph -eq $null) 
    else 
     { # Start Else, if ($ConnectMgGraph -eq $null) 
        Write-Host "The Connections to MgGraph Successful, Continue the script " -ForegroundColor Green
       
       # Get EntraID-Group
       $GetGroupName = Get-MgGroup -GroupId $groupId
       # Get Members in the $Group, Use Pagination
       $members = @()
       $response = Get-MgGroupMember -GroupId $groupId -Top 6000
       $members += $response | Where-Object { $_.AdditionalProperties["@odata.type"] -eq "#microsoft.graph.user" }

       $nextLink = $response.OdataNextLink
       while ($nextLink) { # Start while ($nextLink)
        Write-Host "Get more users from nextlink..."
        $response = Invoke-MgGraphRequest -Method GET -Uri $nextLink
        $response.value | ForEach-Object { # Start ForEach-Object 
          if ($_.'@odata.type' -eq "#microsoft.graph.user") { $members += $_}
        } # End  # Start ForEach-Object 
        $nextLink = $response.'@odata.nextLink'
    } # End while ($nextLink)
    Write-Host "GET-Total Users : $($members.Count)"

       
       # Export members as Csv
      $userList = @()
      $failedUsers = @()
      $i = 1
        foreach ($member in $members)
        # Get Users data in attributes
        { # Start foreach ($member in $members)
         try 
          { # Start Try, Get Users data in attributes
           $user = Get-MgUser -UserId $member.Id -Property "Id,UserPrincipalName,GivenName,Surname,DisplayName,Mail,MobilePhone,BusinessPhones,City,Department,Description,StreetAddress,State,PostalCode,PreferredLanguage"
           Write-host "Processing user $($user.UserPrincipalName) $i" / $($members.Count) -ForegroundColor Yellow
           $i++    
           } # End Try, Get Users data in attributes
         catch 
          {# Start catch, Get Users data in attributes
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            $errorMessage = "$timestamp | Failed Process user : $($user.UserPrincipalName)  $($member.Id) - Fel: $($_.Exception.Message)"
            Write-Host $errorMessage -ForegroundColor Red
            $failedUsers += $errorMessage
            continue
          } # End catch, Get Users data in attributes 

            # Get User Manager
            Try 
            { # Start Try, Get User Manager
              $managerObj = Get-MgUserManager -UserId $user.Id
              if ($managerObj.Id)
              { # Start if ($managerObj.Id)
                $managerUser = Get-MgUser -UserId $managerObj.Id -Property "DisplayName"
                $manager = $managerUser.DisplayName
              } # End if ($managerObj.Id)
              else 
              { # Start Else,if ($managerObj.Id)         
                $manager = "null"     
              } # Start Else,if ($managerObj.Id)
            } # End Try, Get User Manager
            Catch
            { # Start Catch, Get User Manager
              $manager = $null
            } # End Catch, Get User Manager

        # Csv Fields vs EntraID Attributes
        $userList += [PSCustomObject]@{ # Start Csv Fields vs EntraID Attributes
          "User ID"         = Get-ValueOrFallback $user "UserPrincipalName"
          "First name"      = Get-ValueOrFallback $user "GivenName"
          "Last name"       = Get-ValueOrFallback $user "Surname"
          "Email"           = Get-ValueOrFallback $user "mail"         
          "City"            = Get-ValueOrFallback $user "City"
          "Department"      = Get-ValueOrFallback $user "Department"
          "Description"     = Get-ValueOrFallback $user "Description"
          "Location"        = Get-ValueOrFallback $user "StreetAddress"
          "State / Province"= Get-ValueOrFallback $user "State"
          "Street"          = Get-ValueOrFallback $user "StreetAddress"
          "Zip / Postal code" = Get-ValueOrFallback $user "PostalCode"
          "Language"        = Get-ValueOrFallback $user "PreferredLanguage"
          "Manager"         = if ($manager) { $manager } else { "null" }
         } # End Csv Fields vs EntraID Attribute
        } # End foreach ($member in $members)

         # Export Users to CSV
         $csvFileName = "$PSScriptRoot\files\Csv\$($GetGroupName.DisplayName)_Users_$($userList.Count).csv"
         $userList | Export-Csv -Path $csvFileName -NoTypeInformation -Encoding UTF8
         Write-Host "CSV-Export : File saved as: $csvFileName" -ForegroundColor Green

     } # End Else, if ($ConnectMgGraph -eq $null) 

    Write-Host ""
 } # End Try
Catch 
{ # Start Catch
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host "ERROR on $Section" -ForegroundColor Red
    Write-Host "ERROR:" $_.Exception.Message

    Write-Host $Error[0]
   
    Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
    Stop-Transcript
} # End Catch

Stop-Transcript
#------------------------------- End Script -------------------------------
