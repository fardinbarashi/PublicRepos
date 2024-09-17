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
Title :  Kick Users
Description : A Script to kick out users
Version : 1.0
Release day : 2024-09-17
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

$LogOutTime = (Get-Date).AddMinutes(2)
# Error-Settings
$ErrorActionPreference = 'Continue'
#----------------------------------- Start Script ------------------------------------------
Write-Host ""
# Section 1 : Get All logged in RDP-Users
$Section = "Section 1 : Get All logged in RDP-Users"
Try
 { # Start Try, $Section
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
   Write-Host $Section... "0%" -ForegroundColor Yellow
    # Run Query
    Write-Host ""

    $Getsessions = Get-RDUserSession -Verbose   
   
   Write-Host ""
   Write-Host $Section... "100%" -ForegroundColor Green
   
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
Write-Host ""
# Section 2 : force logoff on the users
$Section = "Section 2 : force logoff on the users"
Try
 { # Start Try, $Section
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
   Write-Host $Section... "0%" -ForegroundColor Yellow
    # Run Query
  
    # Send a mess to every user that is logged in
    Foreach ($User in $Getsessions)
     { # Start Foreach ($User in $Getsessions)
       Write-Host "Logging off user: $($UserToGetMess.sessionUserName) On Hostserver $($UserToGetMess.HostServer) with SessionID $($UserToGetMess.UnifiedSessionId)"  
       msg $User.UnifiedSessionId "You will  be logged out in 2 min $($Getdate) according to X daily routine"  
     } # Start Foreach ($User in $Getsessions)
    
    # Wait 120 Sec
    Start-Sleep -Seconds 120

    # Log out users
    Foreach ($LoggedInUser in $Getsessions) 
    { # Start Foreach ($LoggedInUser in $Getsessions) 
      Invoke-RDUserLogoff -HostServer $session.HostServer -UnifiedSessionID $session.UnifiedSessionId -Force -Verbose
    } # End Foreach ($LoggedInUser in $Getsessions) 

    Write-Host "$Section... 100%" -ForegroundColor Green
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


