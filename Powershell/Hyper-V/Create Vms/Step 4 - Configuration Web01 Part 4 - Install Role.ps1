<#
 1. Install Roles, make sure that the drive is loaded with the iso
 

#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"
$VmMachine = "Web01"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "     Step 3 - Part 4: Install Role...                    "         -ForegroundColor Yellow
     Write-Host "                     0 %                                 "         -ForegroundColor Yellow
     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow   


# Step 1 Start
Try 
    { # Start Try, Install Role on $VmMachine "
     Write-Host "Install Role / feature on $VmMachine... 0 % "
      Write-Host "Enter Lab\Username and Password " -ForegroundColor Red
      Invoke-Command -VMName $VmMachine -ScriptBlock{ # Start ScriptBlock 
      
      $IIS = "Web-WebServer","Web-Common-Http","Web-Default-Doc","Web-Dir-Browsing","Web-Http-Errors","Web-Static-Content","Web-Http-Redirect","Web-Health","Web-Http-Logging","Web-Custom-Logging","Web-Log-Libraries","Web-ODBC-Logging","Web-Request-Monitor","Web-Http-Tracing","Web-Performance","Web-Stat-Compression","Web-Security","Web-Filtering","Web-Basic-Auth","Web-Client-Auth","Web-Digest-Auth","Web-Cert-Auth","Web-IP-Security","Web-Windows-Auth","Web-App-Dev","Web-Net-Ext","Web-Net-Ext45","Web-Asp-Net","Web-Asp-Net45","Web-ISAPI-Ext","Web-ISAPI-Filter","Web-Mgmt-Tools","Web-Mgmt-Console"
      Install-WindowsFeature -Name $IIS -Source "D:\sources\"
      } # End ScriptBlock


    } # End Try, Install Role on $VmMachine "

Catch
    { # Start Catch
     Write-Warning -Message "Could not install Role / feature on $VmMachine."
     Write-Error $Error[0]
    } # End Catch




# Step Confirmation
Try 
    { # Start Try Confirmation 
     Write-Host "Install Role / feature on $VmMachine... 100 % "                    -ForegroundColor Green 
     Write-Host ""
     Write-Host " --------------------------------------------------------"         -ForegroundColor Green 
     Write-Host "     Step 3 - Part 4: Install Role...                    "         -ForegroundColor Green
     Write-Host "                     100 %                               "         -ForegroundColor Green
     Write-Host " --------------------------------------------------------"         -ForegroundColor Green   
   
   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step Confirmation


