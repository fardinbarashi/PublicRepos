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

#------------------------------- Settings -------------------------------

# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$FileDate = (Get-Date -Format yyyy/MM/dd/)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt"
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Tenet-Settings
$Settings = Get-Content "$PSScriptRoot\Settings\MsGraphSettings.json" | ConvertFrom-Json
$AppId = $Settings.AppId
$TenantId = $Settings.TenantId
$CertificateThumbprint = $Settings.CertificateThumbprint
$Certificate = Get-ChildItem Cert:\LocalMachine\My\$CertificateThumbprint

# Error-Settings
$ErrorActionPreference = 'Continue'

# Modules to import
Write-Host "Checking required modules..." -ForegroundColor Yellow

$requiredModules = @(
    "Microsoft.Graph.Identity.DirectoryManagement",
    "Microsoft.Graph.Groups"
)

foreach ($module in $requiredModules) {
    Write-Host "`nChecking module: $module" -ForegroundColor Cyan
    
    if (Get-Module -ListAvailable -Name $module) {
        Write-Host "- Module found - Importing..." -ForegroundColor Green
        Import-Module $module -ErrorAction SilentlyContinue
    }
    else {
        Write-Host "- Module not found! - Installing..." -ForegroundColor Yellow
        Install-Module -Name $module -Scope CurrentUser -Force -AllowClobber
        Import-Module $module -Verbose
    }
}

Write-Host "`nAll modules are ready!" -ForegroundColor Green



#------------------------------- Start Script -------------------------------

$Section = "Section 1 : Connect to MgGraph"
Try 
 { # Start Try
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host "Start" $Section -ForegroundColor Yellow

    # Run Query
    Write-Host "Trying to connect to the MgGraph... 0%" -ForegroundColor Yellow
    $ConnectMgGraph = Connect-MgGraph -TenantId $TenantId -Certificate $Certificate -ClientId $AppId

    if ($ConnectMgGraph -eq $null) 
     { # Start if ($ConnectMgGraph -eq $null) 
        Get-Date -Format "yyyy/MM/dd HH:mm:ss"
        Write-Host "ERROR on $section" -ForegroundColor Red
        Write-Warning $Error[0]
        Write-Host "The Connections to MgGraph Failed, check your CertificateThumbprint" -ForegroundColor Yellow
        Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
        Stop-Transcript
        Exit
     } # End if ($ConnectMgGraph -eq $null) 
    else 
     { # Start Else, if ($ConnectMgGraph -eq $null) 
        Write-Host "Trying to connect to the MgGraph... 100%" -ForegroundColor Green
        Write-Host "The Connections to MgGraph Successful, Continue the script " -ForegroundColor Green
        Write-Host "End" $Section -ForegroundColor Green    
      } # End Else, if ($ConnectMgGraph -eq $null) 

    Write-Host ""
 } # End Try
Catch 
{ # Start Catch
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host "ERROR on $Section" -ForegroundColor Red
    Write-Host "ERROR:" $_.Exception.Message
    Write-Host $Error[0]  
    Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
    Stop-Transcript
} # End Catch

Stop-Transcript
