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
Title : FileReportCsv.Ps1
Description : A quick way to get some fileinfo about files that are greater then 10 MB
Version : 1.0
Release day : 2024-09-19
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
# Section 1 : Get all the files and create a report
$Section = "Section 1 : Get all the files and create a report"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
  # Set the source directory
   $sourceDir = ""
 
  # Set the destination CSV file path
   $csvDestination = "$PSScriptRoot\Files\report.csv"
 
  # Get all directories in the source directory that are older than two years or larger than 5GB
   $directories = Get-ChildItem -Path $sourceDir -Recurse -File | 
   Where-Object 
   { # Start Where-Object 
     (Get-Date).AddYears(-10) -gt $_.CreationTime -or $_.Length -gt 10MB
   } # End Where-Object 
 
  # Sort the directories by creation date, size, and alphabetical order
   $sortedDirectories = $directories | Sort-Object -Property CreationTime, Length, FullName
 
  # Create an array of custom objects with the desired properties
   $results = @()
    foreach ($directory in $sortedDirectories) 
     { # Start foreach ($directory in $sortedDirectories) 
      $results += [PSCustomObject]@{ # Start [PSCustomObject]@
        Path = $directory.FullName
        Size = $directory.Length
        DateCreated = $directory.CreationTime
        DateLastAccessed = $directory.LastAccessTime
      } # End [PSCustomObject]@
     } # End foreach ($directory in $sortedDirectories) 
 
  # Export the results to a CSV file
   $results | Export-Csv -Path $csvDestination -NoTypeInformation -Force

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