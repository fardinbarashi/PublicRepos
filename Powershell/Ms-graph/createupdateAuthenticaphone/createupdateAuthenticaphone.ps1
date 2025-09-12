<#

This script loads the csv, and inserts the mobilnumber to user Authenticaphone value, 
if method is missing it will create the method.
Script is using an app-reg with access to API

#>


#------------------------------- Settings -------------------------------

# Transcript
$scriptName = $MyInvocation.MyCommand.Name
$logFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$tranScriptLogFile = "$PSScriptRoot\Logs\$scriptName - $LogFileDate.Txt"
$startTranscript = Start-Transcript -Path $tranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

#Load AssemblyName
Add-Type -AssemblyName System.Security

# Modules to import
Import-Module Microsoft.Graph.Identity.SignIns

# Tenet-Settings
$Settings = Get-Content "$PSScriptRoot\Files\MsGraph\MsGraphSettings.json" | ConvertFrom-Json
$AppId = $Settings.AppId
$TenantId = $Settings.TenantId
$CertificateThumbprint = $Settings.CertificateThumbprint
$Certificate = Get-ChildItem Cert:\LocalMachine\My\$CertificateThumbprint

# Csvfile that 
$csvfile = "$PSScriptRoot\Files\SourceFile\Cleandata.csv" # Sourcefile contains upn and phone
$ReportFile = "$PSScriptRoot\Files\csv\authphone_result_$(Get-Date -Format yyyyMMdd_HHmmss).csv"

# ------------------------------- Start Script -------------------------------
Try
 { # Start Try
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "Trying to connect to the MgGraph 0%..." -ForegroundColor Yellow

  $connectMgGraph = Connect-MgGraph -TenantId $tenantID -Certificate $certificate -ClientId $appID
   if ($connectMgGraph -eq $null)
    { # Start if ($ConnectMgGraph -eq $null)
     Get-Date -Format "yyyy/MM/dd HH:mm:ss"
     Write-Host "ERROR on $section" -ForegroundColor Red
     Write-Warning $error[0]
     Write-Host "The Connections to MgGraph Failed, check your CertificateThumbprint" -ForegroundColor Yellow
     Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
     Stop-Transcript
     Exit
    } # End if ($ConnectMgGraph -eq $null)
   else
    { # Start Else, if ($ConnectMgGraph -eq $null)
     Get-Date -Format "yyyy/MM/dd HH:mm:ss"
     Write-Host "Trying to connect to the MgGraph 100%..." -ForegroundColor Green
     Write-Host "The Connections to MgGraph Successful, Load $($ScriptName)" -ForegroundColor Yellow

     $rows = Import-csv -Path $csvfile -Delimiter ";"
     $summary = @()
     $i = 0; $total = $rows.Count

     $result = foreach ($row in $rows)
     { # Start foreach ($row in $rows)
       $i++
       $upn = $row.upn
       $phone = $row.Phone
   
       Write-Progress -Activity "Authentication phone" -Status "[$i/$total] $upn" -PercentComplete (($i/$total)*100)
       Write-Host ("[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), "Process user: $upn") -ForegroundColor Cyan  

       try
       { # Start Try, update user authenticationphone
        Write-Host "Start update user authenticationphone"
        $user = Get-MgUser -UserId $upn -ErrorAction Stop
        Get-MgUserAuthenticationPhoneMethod -UserId $user.Id -All -ErrorAction Stop
        $methods = Get-MgUserAuthenticationPhoneMethod -UserId $user.Id -All -ErrorAction Stop
        $mobile  = $methods | Where-Object { $_.PhoneType -eq 'mobile' } | Select-Object -First 1

        if ($mobile)
        { # Start if ($mobile)
            Write-Host " Update 'mobile' User $upn -> $phone" -ForegroundColor Yellow
            Update-MgUserAuthenticationPhoneMethod `
                -UserId $user.Id `
                -PhoneAuthenticationMethodId $mobile.Id `
                -PhoneNumber $phone `
                -ErrorAction Stop
            Write-Host " Finished updating 'mobile' User $upn -> $phone" -ForegroundColor Green
            $summary += [pscustomobject]@{User=$upn; Action='Updated'; Phone=$phone; MethodId=$mobile.Id}
        } # End if ($mobile)
        else
        { # Start else, End if ($mobile)
            Write-Host "  Creating 'mobile' för $upn -> $phone" -ForegroundColor Yellow
            $new = New-MgUserAuthenticationPhoneMethod `
                -UserId $user.Id `
                -PhoneType 'mobile' `
                -PhoneNumber $phone `
                -ErrorAction Stop
            Write-Host " Finished creating 'mobile' User $upn -> $phone" -ForegroundColor Green
            $summary += [pscustomobject]@{User=$upn; Action='Created'; Phone=$phone; MethodId=$new.Id}
        } # End else, End if ($mobile)      
       } # End Try, update user authenticationphone
       
       catch
       { # Start catch, update user authenticationphone
        Write-Host $Error[0]
        Write-Host "Failed för $($upn): $($_.Exception.Message)" -ForegroundColor Red
        $summary += [pscustomobject]@{User=$upn; Action='Failed'; Phone=$phone; Error=$_.Exception.Message}
        continue
       } # End catch, update user authenticationphone

     } # End foreach ($row in $rows)
 

     Write-Host "Running Script" -ForegroundColor Yellow
     } # End Else

     # Create Report
     $summary | Format-Table -AutoSize
     $summary | Export-Csv -Path $ReportFile -NoTypeInformation -Encoding UTF8
     
 
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
 
 
