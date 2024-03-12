<#
 1. Start VM
 

#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host " Step 3 - Part 1: Start Clients Before configuration...  "         -ForegroundColor Yellow
     Write-Host "                     0 %                                 "         -ForegroundColor Yellow
     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow   


# Step 1 Start
Try 
    { # Start Try Starting VM
     Write-Host "Starting VM ... 0 % "
     Get-Vm -Name Client01 | Start-VM
     Write-Host "Starting VM ... 100 % " -ForegroundColor Green
     Write-Host "" 
    } # End Try Starting VM

Catch
    { # Start Catch
     Write-Warning -Message "Could not Start VM Client01"
     Write-Error $Error[0]
    } # End Catch

Try 
    { # Start Try Starting VM
     Write-Host "Starting VM ... 0 % "
     Get-Vm -Name Client02 | Start-VM
     Write-Host "Starting VM ... 100 % " -ForegroundColor Green
     Write-Host "" 
    } # End Try Starting VM

Catch
    { # Start Catch
     Write-Warning -Message "Could not Start VM Client02"
     Write-Error $Error[0]
    } # End Catch

Try 
    { # Start Try Starting VM
     Write-Host "Starting VM ... 0 % "
     Get-Vm -Name Client03 | Start-VM
     Write-Host "Starting VM ... 100 % " -ForegroundColor Green
     Write-Host "" 
    } # End Try Starting VM

Catch
    { # Start Catch
     Write-Warning -Message "Could not Start VM Client03"
     Write-Error $Error[0]
    } # End Catch
# Step 1 End

# Step Confirmation
Try 
    { # Start Try Confirmation
     Write-Host " --------------------------------------------------------"         -ForegroundColor Green 
     Write-Host "  Step 3 - Part 1: Start Clients Before configuration... "         -ForegroundColor Green
     Write-Host "                   100 %                 "                         -ForegroundColor Green
     Write-Host " "
     Write-Host "          Login on VMs, Finish the wizard "                        -ForegroundColor Green 
     Write-Host " "      
     Write-Host "          Go to next step,Step 3 - Part 2"                         -ForegroundColor Green   
     Write-Host " --------------------------------------------------------"         -ForegroundColor Green     
   
   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step Confirmation


