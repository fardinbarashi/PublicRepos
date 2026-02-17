
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
Title : AD-User Mobile Number
Description : This scripts takes every users mobile attribute and adds them to a extenstionsattribute2
Script is using mobile attribute sourcedata.
After copied the number to extensionsattribute it format the value to.
It Adds a +46
It removes space and -
Format will be +46799999999
If there is a error change mobileattribute to the right value

A HTML reports is created and mailed.

Version : 1.0
Release day : 2026-02-17
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

# Modules
$requiredModules = @(
    "ActiveDirectory"
)

foreach ($module in $requiredModules) {
    Write-Host "`nChecking module: $module" -ForegroundColor Cyan
    
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "- Module found - Importing..." -ForegroundColor Green
        Import-Module $module -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "- Module not found! - Installing..." -ForegroundColor Yellow
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
        Import-Module $module -Verbose
    }
}
Write-Host "`nAll modules are ready!" -ForegroundColor Green


# Filter
$Filter = { (mobile -like "*") -and (objectClass -eq "user") }

# Error-Settings
$ErrorActionPreference = 'Continue'
#----------------------------------- Start Script ------------------------------------------
# Section 1 : Get all users and selected properties
$Section = "Section 1 : Get all users and selected properties"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
  # Get Every user and propertiy
  $Users = Get-ADUser -Filter $Filter -Properties mobile, extensionAttribute2, mail

  # Create a string for Html-Report
  $Report = @()


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


#-----------------------------------------------------------------------------
# Section 2 : Copy value in attribute mobile to extensionAttribute2, Format the value in extensionAttribute2
$Section = "Section 2 : Copy value in attribute mobile to extensionAttribute2, Format the value in extensionAttribute2"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
  
  # Copy value in attribute mobile to extensionAttribute2 and format the value in extensionAttribute2
  Foreach ($User in $Users)
  { # Start Foreach ($User in $Users)
    $MobileNumber = $User.mobile
    $FormattedNumber = ""

    # Check if $MobileNumber = $User.mobile contains non numeric numbers and change first 0 to +46
     if ($MobileNumber) 
      { # Start if ($MobileNumber)
       
        # remove non numeric numbers except + 
        $CleanedNumber = $MobileNumber -replace '[^0-9+]', ''

        # Check if value in attribute mobilestart with a 0 and change it to +46
        if ($CleanedNumber -match '^0') 
         { # Start if ($CleanedNumber -match '^0') 
          $FormattedNumber = $CleanedNumber -replace '^0', '+46'
         } # End if ($CleanedNumber -match '^0') 

        else 
         { # Start else ($CleanedNumber -match '^0') 
          $FormattedNumber = $CleanedNumber
         } # Start else ($CleanedNumber -match '^0') 

        # Update extensionAttribute2 with the new FormattedNumber
        Set-ADUser -Identity $User.SamAccountName -Replace @{extensionAttribute2 = $FormattedNumber}

        # Add to report
        $Report += [PSCustomObject]@{ # Start $Report += [PSCustomObject]@
         SamAccountName = $User.SamAccountName
         LastName = $User.Surname
         OriginalMobile = $MobileNumber
         FormattedMobile = $FormattedNumber
         Status = "Updated"
        } # End $Report += [PSCustomObject]@
        
        Write-Host "Updated user $($User.Surname) ($($User.SamAccountName)): $MobileNumber -> $FormattedNumber" -ForegroundColor Green

      } # End if ($MobileNumber)

     else 
      { # Start else ($MobileNumber)
        # Add to report if no value is in the attribute mobile
        $Report += [PSCustomObject]@{ # Start $Report += [PSCustomObject]@
            SamAccountName = $User.SamAccountName
            LastName = $User.Surname
            OriginalMobile = "N/A"
            FormattedMobile = "N/A"
            Status = "No Mobile Number"
           } # Start $Report += [PSCustomObject]@ 
      } # End else ($MobileNumber)
    Write-Host "No mobile number for user $($User.Surname) ($($User.SamAccountName))" -ForegroundColor Yellow

  } # End Foreach ($User in $Users)

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



#-----------------------------------------------------------------------------
# Section 3 : Create a html-report
$Section = "Section 3 : Create a html-report"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
  # Generate HTML Report
  $HtmlReport = @"
<html>
<head>
    <style>
        table {
            width: 100%;
            border-collapse: collapse;
            font-family: Arial, sans-serif;
        }
        th, td {
            border: 1px solid #dddddd;
            text-align: left;
            padding: 8px;
        }
        th {
            background-color: #4CAF50;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
    </style>
</head>
<body>
    <h2>AD Mobile Number Update Report</h2>
    <table>
        <tr>
            <th>SamAccountName</th>
            <th>Last Name</th>
            <th>Original Mobile</th>
            <th>Formatted Mobile</th>
            <th>Status</th>
        </tr>
"@

foreach ($Entry in $Report) {
    $HtmlReport += @"
        <tr>
            <td>$($Entry.SamAccountName)</td>
            <td>$($Entry.LastName)</td>
            <td>$($Entry.OriginalMobile)</td>
            <td>$($Entry.FormattedMobile)</td>
            <td>$($Entry.Status)</td>
        </tr>
"@
}

$HtmlReport += @"
    </table>
</body>
</html>
"@

# Save html Report
$HtmlReportPath = "$PSScriptRoot\Files\Report\ADMobileNumberUpdateReport$($LogFileDate).html"
$HtmlReport | Out-File -FilePath $HtmlReportPath -Encoding utf8 -Force

Write-Host "HTML report created at: $HtmlReportPath" -ForegroundColor Cyan
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

#-----------------------------------------------------------------------------
# Section 4 : Mail html report and end script
$Section = "Section 4 : Mail html report and end script"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query

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
