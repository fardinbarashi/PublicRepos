<# Run this script in the folder where you want to create the enviroment.
 
 1. Creates folders after the string $ServerCollection
 2. Creates folders after the string $ClientCollection
 3. Copy $GoldenImageServe to every folder that Step 1 created
 4. Copy $GoldenImageClient to every folder that Step 2 created
 5. Create a Csv-file, Populate it Basename & Fullbase
 6. Creates 3 Virtual Switch
    * ExternalNic
    * InternalNic
    * PrivatNic 
 
 7. Create Vm in hyper-V 
  
#>

$TranscriptLogFile = "$PSScriptRoot\Transcript.txt"

$GoldenImageServer = "$PSScriptRoot\Windows Server 2016.vhdx"
$GoldenImageClient = "$PSScriptRoot\Windows 10.vhdx"

$ServerCollection = "DC01", "Web01", "MsSql01", "ADFS01", "CA01", "App01"
$ClientCollection = "Client01", "Client02", "Client03"

$VHDCsvFile = "$PSScriptRoot\VHDFile.Csv"

Start-Transcript -Path $TranscriptLogFile -Append -Force
Get-Date -Format "yyyy-MM-dd HH:mm"

     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow 
     Write-Host "   Step 1 : Create Enviroment In Hyper-V... "                   -ForegroundColor Yellow
     Write-Host "                     0 %                 "                      -ForegroundColor Yellow
     Write-Host " -----------------------------------------------------"         -ForegroundColor Yellow   

# Step 1 Start
 Try 
    { # Try Create Folders for $ServerCollection - Start
     Write-Host ""
     Write-Host "Creating Folder and copying $GoldenImageServer to $ServerCollection ... 0 % "
     Write-Host ""

     $CreateFoldersServers = Foreach ($FolderName in $ServerCollection ) 
     { # Start Foreach
      Write-Host "Creating folder to $PSScriptRoot\$FolderName... 0% "
      New-Item -Path $PSScriptRoot\ -ItemType "Directory" -Force -Name $FolderName 
      Write-Host "Creating folder to $PSScriptRoot\$FolderName... 100% " -ForegroundColor Green  
      
      Write-Host ""
       
      Write-Host "Copying $GoldenImageServer to $PSScriptRoot\$FolderName... 0% "
      Copy-Item -Path $GoldenImageServer -Force -Destination $PSScriptRoot\$FolderName -Recurse  
      Write-Host "Copying $GoldenImageServer to $PSScriptRoot\$FolderName... 100% " -ForegroundColor Green    
      Write-Host ""         
     } # End Foreach
     Write-Host "Creating Folder and copying $GoldenImageServer to $ServerCollection ... 100 % " -ForegroundColor Green 
    } # # Try Create Folders for $ServerCollection - End
    
 Catch
  { # Start Catch
     Write-Warning -Message "Could Not Creating Folders / Copy image for $ServerCollection "
     Write-Error $Error[0]
  } # End Catch
  # Step 1 End



# Step 2 Start
 Try 
    { # Try Create Folders for $ClientCollection - Start
     Write-Host ""
     Write-Host "Creating Folder and copying $GoldenImageClient to $ClientCollection ... 0 % "
     $CreateFoldersClients = Foreach ($FolderName in $ClientCollection ) 
     { # Start Foreach
      Write-Host "Creating folder to $PSScriptRoot\$FolderName"
      New-Item -Path $PSScriptRoot\ -ItemType "Directory" -Force -Name $FolderName 
      Write-Host "Creating folder to $PSScriptRoot\$FolderName... 100% " -ForegroundColor Green  
      Write-Host ""          
      Write-Host "Copying $GoldenImageClient to $PSScriptRoot\$FolderName"
      Copy-Item -Path $GoldenImageClient -Force -Destination $PSScriptRoot\$FolderName -Recurse
      Write-Host "Copying $GoldenImageClient to $PSScriptRoot\$FolderName... 100% " -ForegroundColor Green   
      Write-Host ""                    
     } # End Foreach
     Write-Host "Creating Folder and copying $GoldenImageClient to $ClientCollection ... 100 % " -ForegroundColor Green 
    } # Try Create Folders for $ClientCollection - End
    
 Catch
  { # Start Catch
     Write-Warning -Message "Could Not Creating Folders / Copy image for $ClientCollection "
     Write-Error $Error[0]
  } # End Catch
# Step 2 End



# Step 3 Start
Try 
    { # Try Rename Server Image after Role - Start
    Write-Host ""  
    Write-Host "Rename Server-Image after folder... 0 % "
    $GetServerCollectionFolders = Get-Childitem -Path $PSScriptRoot\ -Directory
     ForEach ( $Folder In $GetServerCollectionFolders ) 
      { #  Start Foreach
       Get-Childitem -Path $PSScriptRoot\$Folder -File -Exclude "Windows 10*" -Recurse | 
       Foreach { # Start Foreach Rename Item
       Rename-item $_.fullname -new ($_.directory.name + ".Vhdx") 
      } # End Foreach Rename Item
     } # End Foreach
    Write-Host "Rename Server-Image after folder... 100 % " -ForegroundColor Green 
    } #  Try Rename Server Image after Role - End
    
Catch
    { # Start Catch
     Write-Warning -Message "Could Not Rename $GoldenImageServer After Folders in $ServerCollection Folders"
     Write-Error $Error[0]
    } # End Catch
# Step 3 End

# Step 4 Start
Try 
    { # Try Rename Client Image after Os - Start
    Write-Host "Rename Client-Image after folder... 0 % "
    $GetClientCollectionFolders = Get-Childitem -Path $PSScriptRoot\ -Directory
     ForEach ( $Folder In $GetClientCollectionFolders ) 
      { #  Start Foreach
       Get-Childitem -Path $PSScriptRoot\$Folder -File -Include "Windows 10.*" -Recurse |
       Foreach { # Start Foreach Rename Item
       Rename-item $_.fullname -new ($_.directory.name + ".Vhdx")
      } # End Foreach Rename Item
     } # End Foreach
    Write-Host "Rename Client-Image after folder... 100 % " -ForegroundColor Green 
    } # Try Rename Client Image after Os - End
    
Catch
    { # Start Catch
     Write-Warning -Message "Could Not Rename $GoldenImageClient After Folders in $ClientCollection Folders"
     Write-Error $Error[0]
    } # End Catch
# Step 4 End


 
# Step 5 Start
Try 
    { # Create a csv file of the $PSScriptRoot folders
     Write-Host ""  
     Write-Host "Creating Csv file $VHDCsvFile... 0 % "
     $CreateVhdCsvFile = Get-Childitem -Path $PSScriptRoot\ -Directory | Select-Object BaseName, FullName  | Export-Csv -Path $VHDCsvFile -Delimiter "," -Force -Encoding UTF8 -NoTypeInformation
     Write-Host "Creating Csv file $VHDCsvFile... 100 % " -ForegroundColor Green 
    } # # Rename Client Image after Os - End
    
Catch
    { # Start Catch
     Write-Warning -Message "Could Not Create Csvfile $VHDCsvFile "
     Write-Error $Error[0]
    } # End Catch
# Step 5 End

# Step 6 Start
Try 
    { # Try Create Hyper-v Vm-Nics - Start
     Write-Host ""  
     Write-Host "Creating Vm-Switch in hyper-V ... 0 % "
     $ethernet = Get-NetAdapter -Name ethernet
     Write-Host "Creating Vm-Switch-ExternalNic in hyper-V ... 0 % "
     New-VMSwitch -Name ExternalNic -NetAdapterName $ethernet.Name -AllowManagementOS $true -Notes "External"
     Write-Host "Creating Vm-Switch-ExternalNic in hyper-V ... 100 % " -ForegroundColor Green 
     Write-Host ""

     Write-Host "Creating Vm-Switch-InternalNic in hyper-V ... 0 % "
     New-VMSwitch -Name InternalNic -SwitchType Internal -Notes "Internal"
     Write-Host "Creating Vm-Switch-InternalNic in hyper-V ... 100 % " -ForegroundColor Green 
     Write-Host ""

     Write-Host "Creating Vm-Switch-PrivatNic in hyper-V ... 0 % "
     New-VMSwitch -Name PrivatNic -SwitchType Private -Notes "Private"
     Write-Host "Creating Vm-Switch-PrivatNic in hyper-V ... 100 % " -ForegroundColor Green 
    } # Try Create Hyper-v Vm-Nics - End
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not create Vm-Nics in hyper-V"
     Write-Error $Error[0]
    } # End Catch
# Step 6 End

# Step 7 Start
Try 
    { # Try creating Vm in hyper-V - Start 
     Write-Host ""  
     Write-Host "Creating Vm in hyper-V ... 0 % "

      $CreateVmCsvList = Import-csv $VHDCsvFile -Delimiter "," -Encoding UTF8    
       ForEach ( $ComputerObject In $CreateVmCsvList ) 
       { # Start Foreach
        $VMName = $($ComputerObject.BaseName)
        $VMVhdPath = $($ComputerObject.FullName) + "\" + $($ComputerObject.BaseName) + ".Vhdx"
        $VMPath = $($ComputerObject.FullName) + "\"
    
        New-VM -Name $VMName -Path $VMPath -VHDPath $VMVhdPath -SwitchName InternalNic -Generation 2 | 
        Set-VM -CheckpointType Disabled -DynamicMemory -MemoryStartupBytes 8gb -AutomaticCheckpointsEnabled $False
        
       } # End Foreach
     Write-Host ""  
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green 
     Write-Host "   Step 1 : Create Enviroment In Hyper-V Is Finshed"            -ForegroundColor Green 
     Write-Host "                      100 %            "                        -ForegroundColor Green 
     Write-Host ""                                                               -ForegroundColor Green 
     Write-Host "           Go to Step 2 - Configuration... "                    -ForegroundColor Green 
     Write-Host " -----------------------------------------------------"         -ForegroundColor Green     
    } # Try creating Vm in hyper-V - Start  - End
    
Catch
    { # Start Catch
     Write-Warning -Message "Could not create VM in Hyper-V"
     Write-Error $Error[0]
    } # End Catch
# Step 7 End

Stop-Transcript
   