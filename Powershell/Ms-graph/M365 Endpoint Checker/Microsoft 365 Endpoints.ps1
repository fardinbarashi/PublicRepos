<#
System requirements
PSVersion                      5

About Script
Author : Fardin Barashi
Title : Microsoft 365 Endpoints checker
Description : The Office 365 IP Address and URL web service assists users in better identifying and distinguishing Office 365 network traffic, making it easier to assess, configure, and stay updated on changes. This REST-based web service replaces the previously downloadable XML files, which were phased out on October 2, 2018. This script checks for the required IP addresses for M365 Endpoints.
Documentation is available at http://aka.ms/ipurlws
ipadress m365 ( https://learn.microsoft.com/en-us/microsoft-365/enterprise/urls-and-ip-address-ranges?view=o365-worldwide )

Version : 1
Release day : 2023-12-20
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

# Uri
$clientRequestId = [GUID]::NewGuid().Guid
$uri = "https://endpoints.office.com/endpoints/worldwide?NoIPv6=true&clientRequestId=$clientRequestId"


#----------------------------------- Start Script ------------------------------------------

# Section 1 : Connect to Uri
$Section1 = "Section 1 : Connect to $uri"
Try
 { # Start Try, $Section1
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host $Section1... "0%" -ForegroundColor Yellow
  $EndpointSets = Invoke-RestMethod -Uri ($uri) -Verbose
  If ( $EndpointSets -Eq $Null  ) 
     { # Start If, $EndpointSets is empty or null
      Write-host ""
      Get-Date -Format "yyyy/MM/dd HH:mm:ss"
      Write-Host "ERROR on $Section" -ForegroundColor Red
      Write-Host "$EndpointSets is empty or null" -ForegroundColor Red
      Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
      Stop-Transcript
      Exit
     } # End If, $EndpointSets is empty or null
  Else
     { # Start Else, $EndpointSets is Not empty or null
      Write-host ""
      Get-Date -Format "yyyy/MM/dd HH:mm:ss"
      Write-host "Connect to $Uri is successful"
     } # End Else, $EndpointSets is Not empty or null
 } # End Try

Catch
 { # Start Catch
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "ERROR on $Section1" -ForegroundColor Red
  # Get-Errors
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

# Section 2 : Get all the Getting all the Optimize Endpoints and save as a textfile
$Section2 = "Section 2:  Get all the Getting all the Optimize Endpoints and save as a textfile"
Try
 { # Start Try, $Section2
  Write-Host $Section1... "100%" -ForegroundColor Green
  Write-host ""
  
  Write-host ""
  Write-host "-----------"
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host $Section2... "0%" -ForegroundColor Yellow
  
  Write-host ""
  Write-Host "Getting all the Optimize Endpoints" 
  $Optimize = $endpointSets | Where-Object { $_.category -eq "Optimize" }
  $OptimizeIpsv4 = $Optimize.ips | Where-Object { ($_).contains(".") } | Sort-Object -Unique     
  $Optimizedata  = $Optimize 
  Write-Host $OptimizeIpsv4

  Write-host ""
  Write-Host "Saving all the Optimize Endpoints to a textfile" 
  $Optimizedata | out-file -FilePath "$PSScriptRoot\Files\Microsoft Optimize Endpoints data $LogFileDate.Txt" -Verbose -Encoding utf8 -Force   
  $OptimizeIpsv4 | out-file -FilePath "$PSScriptRoot\Files\Microsoft Optimize Endpoints $LogFileDate.Txt" -Verbose -Encoding utf8 -Force

  Write-Host ""
  } # End Try

Catch
 { # Start Catch
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "ERROR on $Section2" -ForegroundColor Red
  # Get-Errors
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


# Section 3 : Get all the Getting all the Allow Endpoints and save as a textfile
$Section3 = "Section 3 :  Get all the Getting all the Allow Endpoints and save as a textfile"
Try
 { # Start Try, $Section3
  Write-Host $Section2... "100%" -ForegroundColor Green
  Write-host ""
  
  Write-host ""
  Write-host "-----------"

  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host $Section3... "0%" -ForegroundColor Yellow

  Write-host ""
  Write-Host "Getting all the Allow Endpoints" 
  $Allow = $endpointSets | Where-Object { $_.category -eq "Allow" }
  $AllowIpsv4 = $Allow.ips | Where-Object { ($_).contains(".") } | Sort-Object -Unique
  $Allowdata  = $Allow
  Write-Host $AllowIpsv4

  Write-host ""
  Write-Host "Saving all the Allow Endpoints to a textfiles"  
  $Allowdata | out-file -FilePath "$PSScriptRoot\Files\Microsoft Allow Endpoints data $LogFileDate.Txt" -Verbose -Encoding utf8 -Force          
  $AllowIpsv4 | out-file -FilePath "$PSScriptRoot\Files\Microsoft Allow Endpoints Ipsv4 $LogFileDate.Txt" -Verbose -Encoding utf8 -Force

  Write-Host ""
 } # End Try

Catch
 { # Start Catch
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "ERROR on $Section3" -ForegroundColor Red
  # Get-Errors
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


# Section 4 : Get all the Getting all the Default Endpoints and save as a textfile
$Section4 = "Section 4 :  Get all the Getting all the Default Endpoints and save as a textfile"
Try
 { # Start Try, $Section4
  Write-Host $Section3... "100%" -ForegroundColor Green
  Write-host ""
  
  Write-host ""
  Write-host "-----------"

  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host $Section4... "0%" -ForegroundColor Yellow

  Write-host ""
  Write-Host "Getting all the Default Endpoints" 
  $Default = $endpointSets | Where-Object { $_.category -eq "Default" }
  $Defaultdata  = $Default
  $DefaultIpsv4 = $Default.urls | Where-Object { ($_).contains(".") } | Sort-Object -Unique
  Write-Host $DefaultIpsv4
            
  Write-host ""
  Write-Host "Saving all the Default Endpoints to a textfiles"  
  $Defaultdata | out-file -FilePath "$PSScriptRoot\Files\Microsoft Default data Endpoints $LogFileDate.Txt" -Verbose -Encoding utf8 -Force          
  $DefaultIpsv4 | out-file -FilePath "$PSScriptRoot\Files\Microsoft Default Endpoints $LogFileDate.Txt" -Verbose -Encoding utf8 -Force

  Write-Host ""
} # End Try

Catch
 { # Start Catch
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "ERROR on $Section4" -ForegroundColor Red
  # Get-Errors
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


