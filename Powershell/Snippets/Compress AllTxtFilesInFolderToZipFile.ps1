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
Title : Compress with 7Zip
Description : Compress all TXT files in a folder to zip file by using 7zip. 
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

# FolderPath 
$SourceFolder = "C:\Temp"

#----------------------------------- Start Script ------------------------------------------
# Section 1 : Compress all TXT files in a folder to zip file by using 7zip.
$Section = "Section 1 : Compress all TXT files in a folder to zip file by using 7zip."
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Create a cmdlet for 7zip
 Write-Host "Create a cmdlet for 7zip"
 Set-Alias Seven-Zip "$env:ProgramFiles\7-Zip\7z.exe" -Verbose

 $GetAllTxtItems = Get-ChildItem -Path $SourceFolder -Filter *.txt -Force -Verbose -Recurse  # Get all text files

 ForEach ($Item in $GetAllTxtItems) 
  { # Start ForEach ($Item in $GetAllTxtItems) 
    Write-host "Compress $($Item.Name) to $($SourceFolder)\Textfiles.zip..."
    # zip all files to $SourceFolder\Textfilez.Zip
    Seven-Zip a -tzip "$SourceFolder\Textfiles.zip" "$SourceFolder\$($Item.Name)"
  } # End ForEach ($Item in $GetAllTxtItems)   
 
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
