<#
 1. change Ip-adress and rename computer
 

#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "       Step 2: Configure Clients...  "                          -ForegroundColor Yellow
     Write-Host "                     0 %                 "                      -ForegroundColor Yellow
     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow   

# Step 1 Start
Try 
    { # Start Try change Ip-adress and rename computer
     Write-Host ""
     Write-Host "Change Ip-adress and rename computer Client01... 0 % "
     Write-Host "" 
     Write-Host ""
        
     Invoke-Command -VMName Client01 -ScriptBlock{ # Start ScriptBlock 
     # Change Nic Settings
      Get-NetAdapter | 
      New-NetIPAddress -AddressFamily IPv4 "10.10.10.101" –PrefixLength 24 -DefaultGateway "10.10.10.2" |
      Set-DnsClientServerAddress -ServerAddresses ("10.10.10.2","10.10.10.3")  |
      Set-NetIPInterface -Dhcp Disabled   
     # Rename Computer
     Rename-Computer -NewName "Client01" -Force | Shutdown -r } # End ScriptBlock
  
   } # End Try change Ip-adress and rename computer
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not change Ip-adress and rename computer Client01"
     Write-Error $Error[0]
    } # End Catch

Try 
    { # Start Try change Ip-adress and rename computer
     Write-Host ""
     Write-Host "Change Ip-adress and rename computer Client02... 0 % "
     Write-Host "" 
     Write-Host ""
        
     Invoke-Command -VMName Client02 -ScriptBlock{ # Start ScriptBlock 
     # Change Nic Settings
      Get-NetAdapter | 
      New-NetIPAddress -AddressFamily IPv4 "10.10.10.102" –PrefixLength 24 -DefaultGateway "10.10.10.2" |
      Set-DnsClientServerAddress -ServerAddresses ("10.10.10.2","10.10.10.3")  |
      Set-NetIPInterface -Dhcp Disabled   
     # Rename Computer
     Rename-Computer -NewName "Client02" -Force | Shutdown -r } # End ScriptBlock
  
   } # End Try change Ip-adress and rename computer
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not change Ip-adress and rename computer Client02"
     Write-Error $Error[0]
    } # End Catch

Try 
    { # Start Try change Ip-adress and rename computer
     Write-Host ""
     Write-Host "Change Ip-adress and rename computer Client03... 0 % "
     Write-Host "" 
     Write-Host ""
        
     Invoke-Command -VMName Client03 -ScriptBlock{ # Start ScriptBlock 
     # Change Nic Settings
      Get-NetAdapter | 
      New-NetIPAddress -AddressFamily IPv4 "10.10.10.103" –PrefixLength 24 -DefaultGateway "10.10.10.2" |
      Set-DnsClientServerAddress -ServerAddresses ("10.10.10.2","10.10.10.3")  |
      Set-NetIPInterface -Dhcp Disabled   
     # Rename Computer
     Rename-Computer -NewName "Client03" -Force | Shutdown -r } # End ScriptBlock
  
   } # End Try change Ip-adress and rename computer
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not change Ip-adress and rename computer Client03"
     Write-Error $Error[0]
    } # End Catch

# Step 1 End

# Step 2 Start
Try 
    { # Start Try Confirmation
     Write-Host "Changing Ip-adress, Rename Machine ... 100 % " -ForegroundColor Green
     Write-Host "" 

     Write-Host " --------------------------------------------------------"          -ForegroundColor Green 
     Write-Host "         Step 3 - Part 2: Configure Clients...            "         -ForegroundColor Green
     Write-Host "                   100 %                 "                          -ForegroundColor Green
     Write-Host " "
     Write-Host " "      
     Write-Host "          Go to next step,Step 3 - Part 3"                          -ForegroundColor Green   
     Write-Host " --------------------------------------------------------"          -ForegroundColor Green     
   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step 2 Start