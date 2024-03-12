<#
 1. Start VM
 

#>
$VmMachine = "MsSql01"

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host " Step 5 - Part 1: Start $VmMachine Before configuration.."         -ForegroundColor Yellow
     Write-Host "                     0 %                                 "         -ForegroundColor Yellow
     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow   


# Step 1 Start
Try 
    { # Start Try Starting VM
     Write-Host "Starting VM ... 0 % "
     Get-Vm -Name $VmMachine | Start-VM
     Write-Host "Starting VM ... 100 % " -ForegroundColor Green
     Write-Host "" 
    } # End Try Starting VM

Catch
    { # Start Catch
     Write-Warning -Message "Could not Start $VmMachine"
     Write-Error $Error[0]
    } # End Catch



# Step Confirmation
Try 
    { # Start Try Confirmation
     Write-Host " --------------------------------------------------------"         -ForegroundColor Green 
     Write-Host "  Step 5 - Part 1: Start $VmMachine Before configuration... "      -ForegroundColor Green
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


