 <#
System requirements
PSVersion                      5.1.19041.2364

About Script :
Author : Fardin Barashi
Title : Get and remove license
Description :
This Script connects to Tenet with reg-app by using a certficate

This script gets the user license and removes them.
Version : 1.0
Release day : 2025-03-24
Github Link  :
News :
 
#>

#----------------------------------- CmdletBinding --------------------------------------


[CmdletBinding()]
Param(
[Parameter(Mandatory=$True)][string]$upn
 )



#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt"
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Load AssemblyName
Add-Type -AssemblyName System.Security

# Settings
$AppId = ""
$TenantId = ""
$CertificateThumbprint = ""
$Certificate = Get-ChildItem Cert:\CurrentUser\My\$CertificateThumbprint

# TestUpn
#$upn="X@Z.onmicrosoft.com" # Test UPN

# Error-Settings
$ErrorActionPreference = 'Continue'

# Modules to import
Import-Module Microsoft.Graph.Identity.DirectoryManagement
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Users.Actions

#----------------------------------- Functions --------------------------------------
# Functions
Function Function-Send-Mail-MsGraph
{ # Start Function-Send-Mail-MsGraph
 $To = ""
 $From = ""
 $errorMailsubject = "PowershellError on Server"
 $errorMailbodyText = @"
 script $ScriptName on server is not working, Check log folder in $PSScriptRoot h
"@

$mailBody = @{
 Message = @{
 Subject = $errorMailsubject
 Body = @{
   ContentType = "Text"
   Content = $errorMailbodyText
  }
 ToRecipients = @(
  @{
    EmailAddress = @{
    Address = $to
   }})
   }
    SaveToSentItems = $false
   }

Send-MgUserMail -UserId $From -BodyParameter $mailBody
} # End Function-Send-Mail-MsGraph




#----------------------------------- Start Script ------------------------------------------
# Section 1 :
$Section = "Section 1 :"
Try
{ # Start Try, $Section
 
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query

  # $ConnectMgGraph = Connect-MgGraph -TenantId $tenantID -CertificateThumbprint $CertificateThumbprint -AppId $AppId
  $ConnectMgGraph = Connect-MgGraph -TenantId $tenantID -CertificateThumbprint $CertificateThumbprint -ClientId $AppId
  If ( $ConnectMgGraph -eq $null )
   { # Start If ( $ConnectMgGraph -eq $null )
     Get-Date -Format "yyyy/MM/dd HH:mm:ss"
     Write-Host "ERROR on $Section" -ForegroundColor Red
     Write-Warning $Error[0]
     write-host "The Connections to MgGraph Failed, check your CertificateThumbprint " -ForegroundColor Yellow
     Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
     Stop-Transcript
     Exit
   } # End If ( $ConnectMgGraph -eq $null )
  Else
   { # Start Else If ( $ConnectMgGraph -eq $null )
     write-host "The Connections to MgGraph Successful, Continue the script " -ForegroundColor Green
     # Run Query
     # Get User
     $user = Get-MgUser -UserId $upn
     Write-Host "Get user $upn" -ForegroundColor Yellow
      if (-not $user) { Write-Host "ERROR: Ingen användare hittades för $upn" -ForegroundColor Red }
     
     Write-Host "Get licenses in the tenet" -ForegroundColor Yellow
     $GetTenentlicensesSku = Get-MgSubscribedSku -All
     Get-MgSubscribedSku -All | Select-Object SkuPartNumber, SkuId, ConsumedUnits, AppliesTo, CapabilityStatus, Id | Format-Table

     Write-Host "Check user licenses is in the tenet" -ForegroundColor Yellow
     $userLicenses = Get-MgUserLicenseDetail -UserId $user.Id  
     if ($userLicenses -Eq $null)
      { # Start if ($assignedLicense -Eq $null)
        Write-Host "String assignedLicense is empty" -ForegroundColor Red
      } # End if ($assignedLicense -Eq $null)
     Else
      { # Else Start if ($assignedLicense -Eq $null)
        Write-Host "String assignedLicense is not empty" -ForegroundColor Yellow
        Write-Host "Start to remove user License" -ForegroundColor Green
        # Remove User license
        Set-MgUserLicense -UserId $User.Id ` -AddLicenses @{} ` -RemoveLicenses $userLicenses.SkuId ` -ErrorAction stop      
      } # End if ($assignedLicense -Eq $null)    
   } # End Else If ( $ConnectMgGraph -eq $null )

 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Function-Send-Mail-MsGraph
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

#----------------------------------- End Script ------------------------------------------
Stop-Transcript


