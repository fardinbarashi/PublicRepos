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

About Script : Template for Ps-5 Scripts
Author : Fardin Barashi
Title : Template Powershell version 5.x
Description : This scripts checks if files have not been moved after a specfic timesetting, team gets notified.
Version : 1.0
Release day : 2024-01-08
Github Link  : https://github.com/fardinbarashi
News : 


#>

#----------------------------------- Settings ------------------------------------------
# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force -Verbose
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Error-Settings
$ErrorActionPreference = 'Continue'

# SMTP Settings
 $MailSubject = "Type MailTitle"
 $MailBody =  "Type MailBody Text , Unc $FileReport"
 $MailTo = "User@Company.com"
 $MailFrom = "larm@Company.com"
 $SmtpServer = ""

 # Timespan Setttngs
$TimeSpanDays = "0"
$TimeSpanHours = "0"
$TimeSpanMins = "0"

# FileType Settings
$Filetypes = "*.xml"

# Path To monitor
$FilePath = ""

#----------------------------------- Start Script ------------------------------------------
# Section 1 : xx
$Section = "Section 1 : Check Files if they are not moved"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 $CheckFiles = @(get-childitem $FilePath -force -Verbose | where {($_.Creationtime -lt (Get-Date).AddDays(-$TimeSpanDays).AddHours(-$TimeSpanHours).AddMinutes(-$TimeSpanMins)) -and ($_.psIsContainer -eq $false)})
  Function GenerateMailForEachFile 
    { # Start Function GenerateMailForEachFile 
      Send-MailMessage -To "$MailTo" -from "$MailFrom" -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8) -Verbose
    } # End Function GenerateMailForEachFile 

    if ($CheckFiles -ne $NULL)
    { # Start If
     For ($Idx = 0; $Idx -lt $CheckFiles.Length; $Idx++)
      { # Start 
        $Files = $CheckFiles[$Idx]
        $FileReport = $Files
        # Generate a mail for each file
        GenerateMailForEachFile
       } # End 
    } # End If
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
