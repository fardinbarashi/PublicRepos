

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

About Script :
Author : Fardin Barashi
Title : Template Powershell version 5.x
Description : Find Inactive Accounts in Active Directory
Version : 1.0
Release day : 2023-01-31
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
#----------------------------------- Start Script ------------------------------------------
# Section 1 : Find Inactive Accounts in Active Directory
$Section = "Section 1 : Find Inactive Accounts in Active Directory"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 $GetInactiveAccounts = Search-AdAccount -AccountInactive -UsersOnly -Timespan 90.00:00:00 | Select-Object SamAccountName, Name, DistinguishedName | Export-Csv "$PSScriptRoot\Files\InactiveAccounts.csv" -Encoding UTF8 -Force
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
