
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

About Script : 
Author : Fardin Barashi
Title : Popuplate AD-Group by using OU
Description : This script populates Base ADgroup with users from BaseOu
FilterOU and Attributes are included.
Version : 1.0
Release day : 2025-01-14
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

# Import-Module
Import-Module ActiveDirectory -Verbose

#-----------------------------------------------------------------------------
# Section 1 : 
$Section = "Section 1 :"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Base AD Group 
 $BaseADGroup = "CN=AAA,OU=BBB,OU=CCC,OU=DDDD,DC=EEE,DC=FFF"
 
 # Base OU
 $BaseOu = "OU=CCC,OU=DDDD,DC=EEE,DC=FFF"
 
# Filtered OUs (excluded OUs)
$FilterOu = @(
    "OU=OU=CCC,OU=DDDD,DC=EEE,DC=FFF",
    "OU=OU=CCC,OU=DDDD,DC=EEE,DC=FFF",
    "OU=OU=CCC,OU=DDDD,DC=EEE,DC=FFF",
    "OU=OU=CCC,OU=DDDD,DC=EEE,DC=FFF"
)
# Filter is user is in these AD-Groups
# AD Groups to check for existing membership
$ADGroup1 = "CN=AAA,OU=BBB,OU=CCC,OU=DDDD,DC=EEE,DC=FFF"
$ADGroup2 = "CN=AAA,OU=BBB,OU=CCC,OU=DDDD,DC=EEE,DC=FFF"
$ADGroup3 = "CN=AAA,OU=BBB,OU=CCC,OU=DDDD,DC=EEE,DC=FFF"

# Fetch all members of AD groups
$GroupMembers1 = Get-ADGroupMember -Identity $ADGroup1 -Recursive | Where-Object { $_.objectClass -eq 'user' } | Select-Object -ExpandProperty DistinguishedName
$GroupMembers2 = Get-ADGroupMember -Identity $ADGroup2 -Recursive | Where-Object { $_.objectClass -eq 'user' } | Select-Object -ExpandProperty DistinguishedName
$GroupMembers3 = Get-ADGroupMember -Identity $ADGroup3 -Recursive | Where-Object { $_.objectClass -eq 'user' } | Select-Object -ExpandProperty DistinguishedName

# Combine all exclusion group members into one list
$ExcludedGroupMembers = $GroupMembers1 + $GroupMembers2 + $GroupMembers3
 
# Fetch all users from Base OU
$AllUsers = Get-ADUser -Filter * -SearchBase $BaseOu -Properties Department, DistinguishedName
 
# Process each user to filter and add to Base AD Group
foreach ($User in $AllUsers) 
{
    $UserDN = $User.DistinguishedName
    $UserDepartment = $User.Department

    # Skip users in excluded OUs
    if ($FilterOu -contains ($FilterOu | Where-Object { $UserDN -like "*$_*" })) 
    {
      Write-Host "Skipping user $($User.SamAccountName): Belongs to excluded OU" -ForegroundColor Yellow
      continue
    }

    # Skip users without a department value
    if ([string]::IsNullOrWhiteSpace($UserDepartment)) 
     {
      Write-Host "Skipping user $($User.SamAccountName): No department value" -ForegroundColor Yellow
      continue
     }

    # Skip users a department value ABC
    if ($UserDepartment -like "ABC")
     {
      Write-Host "Skipping user $($User.SamAccountName): department value is ABC" -ForegroundColor Yellow
      continue
     }


    # Skip users a department value DEF
    if ($UserDepartment -like "DEF")
     {
      Write-Host "Skipping user $($User.SamAccountName): department value is DEF" -ForegroundColor Yellow
      continue
     }

    # Skip users already in excluded groups
    if ($ExcludedGroupMembers -contains $UserDN) 
    {
      Write-Host "Skipping user $($User.SamAccountName): Already in excluded groups" -ForegroundColor Yellow
      continue
    }

    # Add user to Base AD Group
    Write-Host "Adding user $($User.SamAccountName) to $BaseADGroup" -ForegroundColor Green
    Add-ADGroupMember -Identity $BaseADGroup -Members $UserDN -Confirm:$false -Verbose

    # Export users to csv
    Get-ADGroupMember -Identity "GroupName" | Select-Object Name, SamAccountName | Export-Csv -Path 'C:\Temp\Members.csv' -NoTypeInformation -Encoding UTF8 -Force

}
Write-Host "Processing complete. All eligible users have been added to the group." -ForegroundColor Cyan
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