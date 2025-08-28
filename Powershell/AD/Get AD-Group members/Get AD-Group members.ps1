<#
System requirements
PSVersion                      5.1.19041.2364
PSEdition                      Desktop
PSCompatibleVersions           1.0, 2.0, 3.0, 4.0
BuildVersion                   10.0.19041.2364
CLRVersion                     4.0.30319.42000
WSManStackVersion              3.0
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1

About Script : Template for Ps-5 Scripts
Author : Fardin Barashi
Title : Template Powershell version 5.x
Description : A quick way to get all the users in ad-group and export them to a csv file
Version : 1.0
Release day : 2025-08-28
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

$GroupName = "WriteADGroupHere"

# Error-Settings
$ErrorActionPreference = 'Continue'
#----------------------------------- Start Script ------------------------------------------
# Section 1 : xx
$Section = "Section 1 : XX"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 Import-Module ActiveDirectory
 $Output = @()
 
 $Members = Get-ADGroupMember -Identity $GroupName
 $MembersCount = $Members.Count
 foreach ($member in $Members)*
 {
  $user = Get-ADUser $member -Properties DisplayName, SamAccountName, Office, EmailAddress, Department
  
    $Output += [PSCustomObject]@{
        SamAccountName = $user.SamAccountName
        DisplayName    = $user.DisplayName
        EmailAddress   = $user.EmailAddress
        Department     = $user.Department
        Office         = $user.Office
    }
 }

$Output | Export-Csv -Path "$PSScriptRoot\AD-Group - $($GroupName) TotalUsers In Group $($MembersCount) - $($LogFileDate).csv" -NoTypeInformation -Encoding UTF8 -Verbose -Force


 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 Write-Warning $Error[0]
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

#----------------------------------- End Script ------------------------------------------
Stop-Transcript








