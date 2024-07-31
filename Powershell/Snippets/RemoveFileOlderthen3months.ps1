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
Title : Remove files that are older then 3 months in a folder.
Description : Remove files that are older then 3 months in a folder.
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
# Section 1 : Remove files that are older then 3 months in a folder.
$Section = "Section 1 : Remove files that are older then 3 months in a folder."
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
  # Remove files that are older then 3 months in a folder.
   # Datelimit
   $dateLimit = (Get-Date).AddMonths(-3)

   # Get all items in archivePath
   $GetArchiveAstatitems = Get-ChildItem -Path $archivePath -Recurse
   foreach ($item in $GetArchiveAstatitems) 
    { # Start foreach ($item in $GetArchiveAstatitems) 
       
       # Check Folders
       if ($item.PSIsContainer) 
        { # Start if ($item.PSIsContainer) 
         if ($item.LastWriteTime -lt $dateLimit) 
          { # Start if ($item.LastWriteTime -lt $dateLimit) 
            Write-Host "Remove folder: $($item.FullName)"
            Remove-Item -Path $item.FullName -Recurse -Force
          } # End if ($item.LastWriteTime -lt $dateLimit) 
        } # End if ($item.PSIsContainer) 
     
     # Check Files
     else 
      { # Start else,if ($item.LastWriteTime -lt $dateLimit)  
         if ($item.LastWriteTime -lt $dateLimit) 
          { # Start if ($item.LastWriteTime -lt $dateLimit) 
           Write-Host "Remove file: $($item.FullName)"
           Remove-Item -Path $item.FullName -Force
          } # End if ($item.LastWriteTime -lt $dateLimit) 
      } # End else,if ($item.LastWriteTime -lt $dateLimit) 
    
    } # End foreach ($item in $GetArchiveAstatitems) 
 
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





  
