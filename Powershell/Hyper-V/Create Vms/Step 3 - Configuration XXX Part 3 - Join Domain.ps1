<#
 1. Start VM
 

#>
$VmMachine = ""
$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "     Step 3 - Part 3: $VmMachine Join Domain...          "         -ForegroundColor Yellow
     Write-Host "                     0 %                                 "         -ForegroundColor Yellow
     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow   


# Step 1 Start
Try 
    { # Start Try $VmMachine Join domain lab.local
     Write-Host "$VmMachine is joining Domain Lab.local ... 0 % "
     
     Invoke-Command -VMName $VmMachine -ScriptBlock{ # Start ScriptBlock 
      Write-Host "Enter Lab\Username and Password " -ForegroundColor Red
      add-computer –domainname "lab.local"  -restart
     } # End ScriptBlock    
    } # End Try $VmMachine Join domain lab.local

Catch
    { # Start Catch
     Write-Warning -Message "$VmMachine could not join domain lab.local"
     Write-Error $Error[0]
    } # End Catch



# Step Confirmation
Try 
    { # Start Try Confirmation
     Write-Host "$VmMachine has joined domain Lab.local ... 100" -ForegroundColor Green
     Write-Host ""

     Write-Host " --------------------------------------------------------"         -ForegroundColor Green 
     Write-Host "   Step 3 - Part 3: $VmMachine Join Domain...            "         -ForegroundColor Green
     Write-Host "                   100 %                                 "         -ForegroundColor Green                                                               
     Write-Host " "
     Write-Host " "      
     Write-Host "          Go to next step,Step 3 - Part 4"                          -ForegroundColor Green   
     Write-Host " --------------------------------------------------------"          -ForegroundColor Green  

   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step Confirmation


