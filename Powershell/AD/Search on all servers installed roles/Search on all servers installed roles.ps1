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
Title : Get all windows server and roles
Description : If you ever need to query every server in your env after installed roles, this is the script
Version : 1.0
Release day : 2024-12-20
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
# Section 1 : Fetching all Windows Servers from Active Directory
$Section = "Section 1 : Fetching all Windows Servers from Active Directory"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 Write-Host "Fetching all Windows Servers from Active Directory..." -ForegroundColor Green
 $servers = Get-ADComputer -Filter {OperatingSystem -like "*Windows Server*"} -Property Name, IPv4Address, OperatingSystem

 # Save as list
 $serverInfoList = @()

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
# Section 2 : Run command on foreach server
$Section = "Section 2 : Run command on foreach server"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 foreach ($server in $servers) 
  { # Start foreach ($server in $servers) 
    $serverName = $server.Name
    $ipAddress = $server.IPv4Address

    Write-Host "Processing $serverName ($ipAddress) 0%..." -ForegroundColor Yellow
    try 
     { # Start try

       # Invoke Commands
       $rolesAndFeatures = Invoke-Command -ComputerName $serverName -ScriptBlock -Verbose { # Start Scriptblock
       Import-Module ServerManager
       Get-WindowsFeature | Where-Object { $_.Installed -eq $true } | Select-Object -Property DisplayName, Installed
        } -ErrorAction Stop # End Scriptblock
            
       # Add Data to the list
       $serverInfoList += [PSCustomObject]@{ # Start $serverInfoList += [PSCustomObject]
       ComputerName = $serverName
       IPAddress = $ipAddress
       RolesAndFeatures = ($rolesAndFeatures | Select-Object -ExpandProperty DisplayName -ErrorAction SilentlyContinue) -join ", "
        } # End  # Start $serverInfoList += [PSCustomObject]
     } # End Try
    
    catch 
    { # Start Catch    
      Write-Host "Failed to retrieve data for $serverName. Error: $($_.Exception.Message)" -ForegroundColor Red
      $serverInfoList += [PSCustomObject]@{ # Start $serverInfoList += [PSCustomObject]  
      ComputerName = $serverName
      IPAddress = $ipAddress
      RolesAndFeatures = "Failed to retrieve data"
       } # End $serverInfoList += [PSCustomObject]  
    } # End Catch    
 }# End foreach ($server in $servers) 
 Write-Host ""
} # End Try, $Section

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
# Section 3 : Save Output as file
$Section = "Section 3 : Save Output as file"
Try
{ # Start Try, $Section
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Host $Section... "0%" -ForegroundColor Yellow

 # Run Query
 # Exportera till CSV
 $outputFile = "C:\Temp\WindowsServerRoles.csv"
 $serverInfoList | Export-Csv -Path $outputFile -NoTypeInformation -Encoding UTF8 -Force
 Write-Host "Server roles and features report generated: $outputFile" -ForegroundColor Green

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