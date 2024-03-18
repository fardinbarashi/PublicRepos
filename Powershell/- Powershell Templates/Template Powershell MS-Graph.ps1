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

About Script : Template for Ms-Graph
Author : Fardin Barashi
Title : Template Powershell Ms-Graph
Description : A quick startup-template
Version : 1.0
Release day : 2023-05-11 
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

# Parameters
$client_id = "your-client-id-here"
$client_secret = "your-client-secret-here"
$tenant_id = "your-tenant-id-here"
$scope = "https://graph.microsoft.com/.default"

#----------------------------------- Start Script ------------------------------------------
# Section 1 : Get an access token
$Section = "Section 1 : Get an access token"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Get an access token
$body = @{
    client_id     = $client_id
    scope         = $scope
    client_secret = $client_secret
    grant_type    = "client_credentials"
}
$token = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenant_id/oauth2/v2.0/token" -Method POST -Body $body -Verbose

 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red

 Write-Warning "StatusCode:" $_.Exception.Response.StatusCode.value__
 Write-Warning "StatusDescription:" $_.Exception.Response.StatusDescription
 Write-Warning "Response:" $_.Exception.Response.GetResponseStream()
 Write-Warning $Error[0]

 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

# Section 2 : StartProcess
$Section = "Section 2 :StartProcess"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query

 Write-Host ""
} # End Try

Catch
{ # Start Catch
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host "ERROR on $Section" -ForegroundColor Red

 Write-Warning "StatusCode:" $_.Exception.Response.StatusCode.value__
 Write-Warning "StatusDescription:" $_.Exception.Response.StatusDescription
 Write-Warning "Response:" $_.Exception.Response.GetResponseStream()
 Write-Warning $Error[0]

 Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
 Stop-Transcript
 Exit
} # End Catch

#----------------------------------- End Script ------------------------------------------
Stop-Transcript