#------------------------------- Settings -------------------------------

# Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt"
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Load AssemblyName
Add-Type -AssemblyName System.Security

# Tenet-Settings
$Settings = Get-Content "$PSScriptRoot\files\MsGraph\MsGraphSettings.json" | ConvertFrom-Json
$AppId = $Settings.AppId
$TenantId = $Settings.TenantId
$CertificateThumbprint = $Settings.CertificateThumbprint
$Certificate = Get-ChildItem Cert:\LocalMachine\My\$CertificateThumbprint


# Error-Settings
$ErrorActionPreference = 'Continue'

# Modules to import
Import-Module Microsoft.Graph.Identity.DirectoryManagement

#------------------------------- Functions -------------------------------

Function Function-Send-Mail-MsGraph {
    $toFardin = ""
    $from = ""
    $errorMailSubject = "PowershellError from machine $($env:COMPUTERNAME)))"
    $errorMailBodyText = @"
Script $ScriptName on machine $($env:COMPUTERNAME)  $PSScriptRoot have failed.
See the log and check the error message.
The log file is located in $TranScriptLogFile
"@

    $mailBody = @{
        Message = @{
            Subject = $errorMailSubject
            Body = @{
                ContentType = "Text"
                Content = $errorMailBodyText
            }
            ToRecipients = @(
                @{ EmailAddress = @{ Address = $toFardin } }
            )
        }
        SaveToSentItems = $false
    }

    Send-MgUserMail -UserId $from -BodyParameter $mailBody
}

#------------------------------- Start Script -------------------------------

$Section = "Section 1 :"
Try {
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host $Section.. " 08" -ForegroundColor Yellow

    # Run Query
    Write-Host "Trying to connect to the MgGraph" -ForegroundColor Yellow
    $ConnectMgGraph = Connect-MgGraph -TenantId $TenantId -Certificate $Certificate -ClientId $AppId

    if ($ConnectMgGraph -eq $null) {
        Get-Date -Format "yyyy/MM/dd HH:mm:ss"
        Write-Host "ERROR on $section" -ForegroundColor Red
        Write-Warning $Error[0]
        Write-Host "The Connections to MgGraph Failed, check your CertificateThumbprint" -ForegroundColor Yellow
        Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
        Stop-Transcript
        Exit
    } else {
        Write-Host "The Connections to MgGraph Successful, Continue the script " -ForegroundColor Green


    }

    Write-Host ""
}
Catch {
    Get-Date -Format "yyyy/MM/dd HH:mm:ss"
    Write-Host "ERROR on $Section" -ForegroundColor Red
   
    Write-Warning "StatusCode:" $_.Exception.Response.StatusCode.value__
    Write-Warning "StatusDescription:" $_.Exception.Response.StatusDescription
    Write-Warning "Response:" $_.Exception.Response.GetResponseStream()
    Write-Warning $Error[0]
   
    Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
    Stop-Transcript
}

Stop-Transcript
#------------------------------- End Script -------------------------------
