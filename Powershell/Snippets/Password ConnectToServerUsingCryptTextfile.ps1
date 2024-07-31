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
Title : Connect to server using a crypt textfile
Description : Connect to server using a crypt textfile
Version : 1.0
Release day : 2024-07-31
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
# Section 1 : Create and save crypt password in a textfile
$Section = "Section 1 : Create and save crypt password in a textfile"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Get Password txt file 
  $EncryptedPassword = Get-Content -Path "C:\Temp\Password.txt"

  # Convert to a SecureString
  $SecurePassword = $EncryptedPassword | ConvertTo-SecureString

  # Crete PSCredential
  $Credentials = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Domain\Serviceaccount",$SecurePassword

  # Connect to server crete psdrive
  New-PSDrive -Name Target -PSProvider FileSystem -Root "\\Servername\C$\Temp\" -Credential $Credentials -Scope Global | Out-Null
 
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
