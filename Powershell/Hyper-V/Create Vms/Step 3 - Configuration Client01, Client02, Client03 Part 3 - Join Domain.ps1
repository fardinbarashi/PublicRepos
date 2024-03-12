<#
 1. Start VM
 

#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "     Step 3 - Part 3: Clients Join Domain...             "         -ForegroundColor Yellow
     Write-Host "                     0 %                                 "         -ForegroundColor Yellow
     Write-Host " --------------------------------------------------------"         -ForegroundColor Yellow   


# Step 1 Start
Try 
    { # Start Try Client01 Join domain lab.local
     Write-Host "Client01 is joining Domain Lab.loca ... 0 % "
     
     Invoke-Command -VMName Client01 -ScriptBlock{ # Start ScriptBlock 
      Write-Host "Enter Lab\Username and Password " -ForegroundColor Red
      add-computer –domainname "lab.local"  -restart
     } # End ScriptBlock    
    } # End Try Client01 Join domain lab.local

Catch
    { # Start Catch
     Write-Warning -Message "Client01 could not join domain lab.local"
     Write-Error $Error[0]
    } # End Catch

Try 
    { # Start Try Client02 Join domain lab.local
     Write-Host "Client01 is joining Domain Lab.local ... 100 % " -ForegroundColor Green
     Write-Host "" 

     Write-Host "Client02 is joining Domain Lab.local ... 0 % "
     
     Invoke-Command -VMName Client02 -ScriptBlock{ # Start ScriptBlock 
      Write-Host "Enter Lab\Username and Password " -ForegroundColor Red
      add-computer –domainname "lab.local"  -restart
     } # End ScriptBlock
    } # End Try Client02 Join domain lab.local

Catch
    { # Start Catch
     Write-Warning -Message "Client02 could not join domain lab.local"
     Write-Error $Error[0]
    } # End Catch

Try 
    { # Start Try Client03 Join domain lab.local
     Write-Host "Client02 is joining Domain Lab.local ... 100 % " -ForegroundColor Green
     Write-Host "" 

     Write-Host "Client03 is joining Domain Lab.local ... 0 "
     
     Invoke-Command -VMName Client03 -ScriptBlock{ # Start ScriptBlock 
      Write-Host "Enter Lab\Username and Password " -ForegroundColor Red
      add-computer –domainname "lab.local"  -restart
     } # End ScriptBlock

    } # End Try Client03 Join domain lab.local

Catch
    { # Start Catch
     Write-Warning -Message "Client03 could not join domain lab.local"
     Write-Error $Error[0]
    } # End Catch



# Step Confirmation
Try 
    { # Start Try Confirmation
     Write-Host "Client03 is joining Domain Lab.local ... 100" -ForegroundColor Green
     Write-Host "" 

     Write-Host " --------------------------------------------------------"         -ForegroundColor Green 
     Write-Host "   Step 3 - Part 3: Clients Join Domain...              "          -ForegroundColor Green
     Write-Host "                   100 %                                 "         -ForegroundColor Green                                                               
     Write-Host " --------------------------------------------------------"         -ForegroundColor Green 
   
   } # End Try Confirmation
    
Catch
    { # Start Catch
     Write-Warning -Message "Script could not be runned"
     Write-Error $Error[0]
    } # End Catch
# Step Confirmation


