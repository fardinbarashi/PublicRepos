<#

  1. Install Roles
     * AD-Domain-Services
     * DHCP
     * DNS

  2. Promte Server to domain controller
  Line 57, type in password

#>


$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"
     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "  Step 2 : Install Roles on DC01...         "                   -ForegroundColor Yellow
     Write-Host "                     0 %                 "                      -ForegroundColor Yellow
     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow   


# Step 1 Start
Try 
    { # Start Try, Install Roles, AD-Domain-Services, DHCP, DNS 
      Write-Host "Install AD-Domain-Services, DHCP, DNS... 0% "
      Write-Host "" 
      
      Invoke-Command -VMName DC01 -ScriptBlock{ # Start ScriptBlock 
       install-windowsfeature AD-Domain-Services –IncludeManagementTools
       install-windowsfeature DHCP –IncludeManagementTools
       install-windowsfeature DNS –IncludeManagementTools    
     } # End ScriptBlock
     
     Write-Host "" 
     Write-Host "Install AD-Domain-Services, DHCP, DNS... 100% " -ForegroundColor Green
     Write-Host "" 
    } # End Try, Install Roles, AD-Domain-Services, DHCP, DNS
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not Install Roles, AD-Domain-Services, DHCP, DNS "
     Write-Error $Error[0]
    } # End Catch
# Step 1 End

# Step 2 Start
Try 
    { # Start Try, Promte Server to domain controller
    Write-Host "Promte Server to domain controller... 0% "
    Write-Host "" 

     Invoke-Command -VMName DC01 -ScriptBlock{ # Start ScriptBlock 
      Import-Module ADDSDeployment
       Install-ADDSForest `
        -SafeModeAdministratorPassword (ConvertTo-SecureString 'Jbpkg18!' -AsPlainText -Force) `
        -CreateDnsDelegation:$false `
        -DatabasePath "C:\Windows\NTDS" `
        -DomainMode "WinThreshold" `
        -DomainName "lab.local" `
        -DomainNetbiosName "LAB" `
        -ForestMode "WinThreshold" `
        -InstallDns:$true `
        -LogPath "C:\Windows\NTDS" `
        -NoRebootOnCompletion:$false `
        -SysvolPath "C:\Windows\SYSVOL" `
        -Force:$true
     } # End ScriptBlock
     
    } # End Try, Promte Server to domain controller
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not Promte Server to domain controller "
     Write-Error $Error[0]
    } # End Catch
# Step 2 End

# Step Confirmation
Try 
    { # Start Try Confirmation
        Write-Host "" 
    Write-Host "Promte Server to domain controller... 100% " -ForegroundColor Green
    Write-Host ""
    
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green 
     Write-Host " Step 2 : Install Roles on DC01...         "                    -ForegroundColor Green
     Write-Host "                   100 %                 "                      -ForegroundColor Green
     Write-Host " "
     Write-Host " Login on VM, Finish the DHCP wizard "                          -ForegroundColor Green 
     Write-Host " "      
     Write-Host " Run the other powershellscript per server"                     -ForegroundColor Green   
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green      
   
   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step Confirmation

