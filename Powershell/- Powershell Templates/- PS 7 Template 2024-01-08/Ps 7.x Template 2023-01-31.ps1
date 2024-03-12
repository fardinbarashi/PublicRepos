<#
System requirements
PSVersion                      7.3.1
PSEdition                      Core
GitCommitId                    7.3.1
PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0…}
PSRemotingProtocolVersion      2.3
SerializationVersion           1.1.0.1
WSManStackVersion              3.0  

About Script : Template for Ps-7 Scripts
Author : Fardin Barashi
Title : Template Powershell version 7.x
Description : A quick startup-template
Version : 1
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
# Section 1 : xx
$Section = "Section 1 : XX"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow
 Get-ChildIteml -Path c:\tempa 
 # Run Query

 Write-Host ""
} # End Try

Catch
{ # Start Catch
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red
 # Get-Errors
 Get-Error
 Write-Warning $Error[0]
 Write-Warning $Error[0].CategoryInfo
 Write-Host ""
 Write-Warning $Error[0].InvocationInfo
 Write-Host ""
 Write-Warning $Error[0].Exception
 Write-Host ""
 Write-Warning $Error[0].FullyQualifiedErrorId
 Write-Host ""
 Write-Warning $Error[0].PipelineIterationInfo
 Write-Host ""
 Write-Warning $Error[0].ScriptStackTrace
 Write-Host ""
 Write-Warning $Error[0].TargetObject
 Write-Host ""
 Write-Warning $Error[0].PSMessageDetails
 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

#----------------------------------- End Script ------------------------------------------
Stop-Transcript
