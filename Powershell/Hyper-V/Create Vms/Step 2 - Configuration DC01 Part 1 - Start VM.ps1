<#
 1. Start VM
 

#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "  Step 2 : Start DC01 Before configuration...         "         -ForegroundColor Yellow
     Write-Host "                     0 %                 "                      -ForegroundColor Yellow
     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow   


# Step 1 Start
Try 
    { # Start Try Starting VM
     Write-Host "Starting VM ... 0 % "
     Get-Vm -Name DC01 | Start-VM
     Write-Host "Starting VM ... 100 % " -ForegroundColor Green
     Write-Host "" 



    } # End Try Starting VM

Catch
    { # Start Catch
     Write-Warning -Message "Could not Start VM"
     Write-Error $Error[0]
    } # End Catch
# Step 1 End

# Step Confirmation
Try 
    { # Start Try Confirmation
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green 
     Write-Host "  Step 2 : Start DC01 Before configuration...         "         -ForegroundColor Green
     Write-Host "                   100 %                 "                      -ForegroundColor Green
     Write-Host " "
     Write-Host " Login on VM, Finish the wizard "                               -ForegroundColor Green 
     Write-Host " "      
     Write-Host " Go to next step, DC01 Part 2 - Change Nic,Rename PC.."         -ForegroundColor Green   
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green     
   
   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step Confirmation


