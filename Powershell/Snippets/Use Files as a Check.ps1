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
Title :  Uses a filelist as a check in folder
Description : Uses a filelist as a check in folder
Version : 1.0
Release day : 2023-07-29
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

# Script settings


#----------------------------------- Start Script ------------------------------------------
# Section 1 : Get allFiles in $FilesPath
$Section = "Section 1 : Get allFiles in $FilesPath"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Get allFiles in $FilesPath
 $GetFiles = Get-ChildItem -Path $FilesPath -Recurse | Select-Object -ExpandProperty Name
 # String to check if all files exist
 $allFilesExist = $true

foreach ($Files in $FileList) 
{ # Start foreach ($Files in $FileList) 
    if ($GetFiles -contains $GetFiles) 
     { # Start if ($GetFiles -contains $GetFiles) 
        Write-Host "all Files Exist"
     } # End if ($GetFiles -contains $GetFiles) 
    
    else 
    { # Start else, if ($GetFiles -contains $GetFiles) 
        # String to check if all files does not exist
        $allFilesExist = $false
        Write-Host "all Files does not Exist"
    } # End else, if ($GetFiles -contains $GetFiles) 

} # End foreach ($Files in $FileList) 
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

#----------------------------------- Start Script ------------------------------------------
# Section 2 : Create Action based on condition
$Section = "Section 2 : Create Action based on condition"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 if ($allFilesExist) 
  { # Start if ($allFilesExist)  
    Write-Host "" 
    Write-Host "Do This"
  } # End if ($allFilesExist)  
 else
  { # Start else, if ($allFilesExist)  
    Write-Host ""
    Write-Host "Shutdown script"
  } # End else, if ($allFilesExist) 
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
