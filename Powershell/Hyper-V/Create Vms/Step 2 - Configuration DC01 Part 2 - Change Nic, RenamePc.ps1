<#
 1. change Ip-adress and rename computer
 

#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "  Step 2 : Configure DC01 Before Role Installation... "         -ForegroundColor Yellow
     Write-Host "                     0 %                 "                      -ForegroundColor Yellow
     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow   

# Step 1 Start
Try 
    { # Start Try change Ip-adress and rename computer
     Write-Host ""
     Write-Host "Change Ip-adress and rename computer ... 0 % "
     Write-Host "" 
     Write-Host ""
        
     Invoke-Command -VMName DC01 -ScriptBlock{ # Start ScriptBlock 
     # Change Nic Settings
      Get-NetAdapter | 
      New-NetIPAddress -AddressFamily IPv4 "10.10.10.2" –PrefixLength 24 -DefaultGateway "10.10.10.2" |
      Set-DnsClientServerAddress -ServerAddresses ("10.10.10.2","10.10.10.3")  |
      Set-NetIPInterface -Dhcp Disabled   
     # Rename Computer
     Rename-Computer -NewName "DC01" -Force | Shutdown -r } # End ScriptBlock
   
   } # End Try change Ip-adress and rename computer
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not change Ip-adress and rename computer"
     Write-Error $Error[0]
    } # End Catch

# Step 1 End

# Step 2 Start
Try 
    { # Start Try Confirmation
     Write-Host "Changing Ip-adress, Rename Machine ... 100 % " -ForegroundColor Green
     Write-Host "" 
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green 
     Write-Host "  Step 2 : Configure DC01 Before Role Installation... "         -ForegroundColor Green
     Write-Host "                   100 %                 "                      -ForegroundColor Green
     Write-Host " Go to next step, DC01 Part 3 - Install Role"                   -ForegroundColor Green   
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green   
   
   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step 2 Start