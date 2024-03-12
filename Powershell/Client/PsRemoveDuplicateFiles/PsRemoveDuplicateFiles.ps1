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


.SYNOPSIS
A script to remove duplicate files from a folder and save disk space.

.DESCRIPTION
This script prompts the user to enter the path to the folder they want to search in. It retrieves a list of all files in the specified folder and its subfolders, counts the occurrences of each file name using a hashtable, and identifies files with more than one occurrence.
For each file with multiple occurrences, the script prompts the user with the file's full path and asks if they want to delete it.
If the user chooses to delete the file, it will be removed using the Remove-Item cmdlet with the -Force flag, which forces deletion without confirmation.
If the user chooses not to delete the file or enters an invalid choice, the script skips the deletion and moves on to the next file.

.PARAMETER folderPath
The path to the folder where duplicate files will be searched and removed.

.NOTES
Version: 1.0
Author: Fardin Barashi
Release Date: 2023-01-31
Github: https://github.com/fardinbarashi

#>

#----------------------------------- Settings ------------------------------------------

# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format "yyyy/MM/dd/HH.mm.ss")
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host "Starting Transcript..."

# Error Settings
$ErrorActionPreference = 'Continue'


#----------------------------------- Start Script ------------------------------------------

$Section = "Section 1 : Loop Files and check after duplicates"

Try { # Start Try
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host "Starting script..."
    Write-Host ""
    # Specify the path to the folder you want to search in
    $folderPath = "ADD YOUR FOLDER"

    # Get a list of all files in the folder and its subfolders
    $files = Get-ChildItem -Path $folderPath -Recurse -File

    # Create a hashtable to store file names and their occurrence count
    $fileNameCount = @{}

    # Loop through the list of files and count the occurrences of each file name
    foreach ($file in $files) 
     { # Start foreach ($file in $files) 
        $fileName = $file.Name
        if ($fileNameCount.ContainsKey($fileName)) 
         { # Start if ($fileNameCount.ContainsKey($fileName)) 
            $fileNameCount[$fileName] += @($file)
         } # End if ($fileNameCount.ContainsKey($fileName)) 
        else 
         { # Start else
            $fileNameCount[$fileName] = @($file)
         } # End  else
     } # End foreach ($file in $files) 

    # Loop through the hashtable and prompt the user to delete files with more than one occurrence
    foreach ($fileName in $fileNameCount.Keys) 
     { # Start foreach ($fileName in $fileNameCount.Keys) 
        $filesList = $fileNameCount[$fileName]
        $count = $filesList.Count
        if ($count -gt 1) 
         { # Start if ($count -gt 1) 
            Write-Host "Duplicate files found for the name: $fileName" -ForegroundColor Red
            Write-Host "Source file: $($filesList[0].FullName), Size: $([math]::Round($filesList[0].Length / 1MB, 2)) MB" -ForegroundColor Yellow
            for ($i = 1; $i -lt $count; $i++) 
             { # Start for ($i = 1; $i -lt $count; $i++) 
                $duplicateFile = $filesList[$i]
                Write-Host "Duplicate file: $($duplicateFile.FullName), Size: $([math]::Round($duplicateFile.Length / 1MB, 2)) MB" -ForegroundColor DarkYellow
                $confirmationMessage = "Do you want to delete the duplicate file: $($duplicateFile.FullName)? (Y/N)"
                $choice = Read-Host $confirmationMessage
                if ($choice -eq "Y" -or $choice -eq "y") 
                 { # Start if ($choice -eq "Y" -or $choice -eq "y") 
                    Remove-Item -Path $duplicateFile.FullName -Force
                    Write-Host "Duplicate file deleted: $($duplicateFile.FullName)"
                    Write-host ""
                 } # End ($choice -eq "Y" -or $choice -eq "y") 
                else 
                 { # Start else
                    Write-Host "Skipped deletion of duplicate file: $($duplicateFile.FullName)"
                    Write-host ""
                 } # End else 
            } # End  # Start for ($i = 1; $i -lt $count; $i++) 
            Write-Host
        } # End if ($count -gt 1) 
    } # End foreach ($fileName in $fileNameCount.Keys) 
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