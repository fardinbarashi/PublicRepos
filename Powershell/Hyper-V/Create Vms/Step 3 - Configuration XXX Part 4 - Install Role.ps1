<#
 1. Join domain

#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"
$VmMachine = ""

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


