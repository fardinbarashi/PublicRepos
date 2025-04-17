<#
 VHDX-Checker
 VHDX-Checker controlls the freespace in Each VHDX in $VhdxShare = "$PSScriptRoot\VhdxShare\
 IF the freespace is Less or Equel to the value in $Threshold in %.
 The script will then create a new size based on string $sizeIncrease = $Size * (0.2) # Increase value with 20 %
 If you want to change the new size to 10 % you can use line $sizeIncrease = $Size * (0.1)
 Diskpart config files is used by Diskpart to select vdisk and extend the partition

 Run as Admin
 Works only with fixed size on VHDX

 Version 1:0 2023-01-18
#>


# Settings
 # Transcript
 $LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
 $TranScriptLogFile = "$PSScriptRoot\Logs\$LogFileDate.Txt" 
 
 # VHDX-Settings
 # FilePath
  $VhdxShare = "$PSScriptRoot\VhdxShare\" # FilePath to VHDX share
  $DiskPartConfig = "$PSScriptRoot\DiskPartConfig\*.txt" # Folder where the diskpart will get all configs

 # ------------------------------- Start Script -------------------------------
 
 $StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force | Out-String | Write-Verbose -Verbose
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
 Write-Output "Script Started"
 Write-Output ""

## VHDX
# Mount VHDX - Get all the VHDX, Check if they are free, Mount Them
 # Get VHDX-Share
 $GetVhdxShare = Get-ChildItem -Path $VhdxShare -Recurse -Exclude 'UVHD-template.vhdx' -Include '*.vhdx' -ErrorAction SilentlyContinue | 
 Where-Object { $_.Name -like '*.vhdx' }

  Foreach ( $VhdxImage in $GetVhdxShare ) 
   { # Start Foreach ( $VhdxImage in $GetVhdxShare )  
    Try 
     { # Start Try
       If(Test-Path -Path $VhdxImage.FullName -PathType Leaf)
        { # Start If(Test-Path -Path $Vhdx.FullName -PathType Leaf)
         # Check If VHDX is Free
         $CheckVhdX = [System.IO.File]::Open("$VhdxImage", "Open", "ReadWrite", "None")
         $CheckVhdX.Close()
         
         # Mount Vhdx
         $MountVhdxShare = Mount-VHD -Path $VhdxImage.FullName -NoDriveLetter -ErrorAction SilentlyContinue -Verbose 
         $CheckMountedVhdx = Get-VHD -Path $VhdxImage.FullName
         # Check if Vhdx is Attached
        if ($CheckMountedVhdx.Attached) 
         { # Start if ($CheckMountedVhdx.Attached) 
          Write-Output "The $($VhdxImage.FullName) is mounted."
          # Create Custom Object
          Write-Output "Create CustomObject to $($VhdxImage.FullName)"
          Write-Output ""
          # Custom Object Query
          $GetDiskVirtual = Get-Disk -FriendlyName "MSFT Virtual Disk" 
          $GetVolume = Get-Disk -FriendlyName "MSFT Virtual Disk" | Get-Partition | Where-Object { $_.Type -Eq "IFS"} | Get-Volume 
          # Custom Object
          $VhdxObject = New-Object -TypeName PSCustomObject
          $VhdxObject | Add-Member -MemberType NoteProperty -Name Number -Value $GetDiskVirtual.Number 
          $VhdxObject | Add-Member -MemberType NoteProperty -Name Path -Value $GetVhdxShare.FullName   
          $VhdxObject | Add-Member -MemberType NoteProperty -Name UniqueId -Value $GetDiskVirtual.UniqueId   
          $VhdxObject | Add-Member -MemberType NoteProperty -Name Size -Value $GetVolume.Size 
          $VhdxObject | Add-Member -MemberType NoteProperty -Name SizeRemaining -Value $GetVolume.SizeRemaining

          # Calculate Freespace for each VHDX
          Foreach ( $MountedVhdx In $CheckMountedVhdx) 
          { # Start Foreach ( $MountedVhdx In $CheckMountedVhdx) 
           $GetVolume | ForEach-Object {
            # Start $GetVolume | ForEach-Object
            $Size = $_.Size
            $SizeRemaining = $_.SizeRemaining
            $Threshold = 20 # Value in %
            $Size = [int]$Size
            $SizeRemaining = [int]$SizeRemaining
            $remainingSizePct = ($SizeRemaining / $Size) * 100
            
            $DiskPartConfigFile = "$PSScriptRoot\DiskPartConfig\$LogFileDate\diskpart-config-$($MountedVhdx.DiskIdentifier).txt"

            if ($remainingSizePct -lt $Threshold) 
             { # Start if ($remainingSizePct -lt $Threshold) 
                # Size remaining is less than $Threshold%"
                 # create more freespace
                  $sizeIncrease = $Size * (0.2) # Increase value with 20 %
                  $NewSize = $Size + $sizeIncrease
                  $ResizeVHD = Resize-VHD -Path $MountedVhdx.Path -SizeBytes $NewSize -Verbose -ErrorAction Continue

                    # DiskPart, Create DiskPart Config File
                    New-Item -Path $DiskPartConfigFile -Force
                    Add-Content -Value "select vdisk file='$($MountedVhdx.Path)'" -Path "$DiskPartConfigFile"
                    Add-Content -Value "select disk $($MountedVhdx.Number)" -Path $DiskPartConfigFile
                    Add-Content -Value "select partition 1" -Path $DiskPartConfigFile
                    Add-Content -Value "extend" -Path $DiskPartConfigFile
                    Add-Content -Value "exit" -Path $DiskPartConfigFile             
                    
                    # Add $NewSize to the volume with DiskPart
                   diskpart /s $DiskPartConfigFile

             } # End if ($remainingSizePct -lt $Threshold) 
            else 
             { # Start else, if ($remainingSizePct -lt $Threshold) 
                # Size remaining is more than $Threshold%"
             } # End else, if ($remainingSizePct -lt $Threshold) 
           } # End $GetVolume | ForEach-Object 
          } # End Foreach ( $MountedVhdx In $CheckMountedVhdx) 
         }  # End if ($CheckMountedVhdx.Attached) 
         
        else 
         {  # Start else ($CheckMountedVhdx.Attached) 
          Write-Output "The $($VhdxImage.FullName) is not mounted."
         } # End else ($CheckMountedVhdx.Attached) 
        } # End Foreach( $GVhdx in $GetVhdx ) 
     } # End Try
    
    Catch [System.IO.IOException]
     { # Start Catch
       Write-Output "Skipping checking on $($VhdxImage) because the VHDX is BUSY"
     } # Start Catch
  } # End Foreach ( $Vhdx in $GetVhdxs )  



### Alert Team about VHDX files
 Try 
  { # Start Try, Alert Team about VHDX files
    # Run Query
     $GetDiskPartConfigFiles = Get-ChildItem -Path "$PSScriptRoot\DiskPartConfig\$LogFileDate\*" -Recurse
     IF ( $GetDiskPartConfigFiles.count -Eq $Null )
      { # Start IF ( $GetDiskPartConfigFiles.count -Eq $Null )
        # No VHDX has been affected
      } # End IF ( $GetDiskPartConfigFiles.count -Eq $Null )
     Else
      { # Start Else,  IF ( $GetDiskPartConfigFiles.count -Eq $Null )
       Write-Output ""
       Write-Output "--------------------"
       Write-Output $MailSubject = " VHDX-Checker Rapport $($LogFileDate) "  #  MailSubject
       Write-Output $MailBody = "During the execution of the script, the number of VHDXs that get increased in size is $($GetDiskPartConfigFiles.count) VHDX. Vhdx $($CheckMountedVhdx.Path). For more details see the log file $TranScriptLogFile" # MailBody    
       $SmtpServer = ""
       $MailFrom = ""
       $MailTo = ""
       # Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8)      
      } # End Else, IF ( $GetDiskPartConfigFiles.count -Eq $Null )
  } # End Try, Alert Team about VHDX files

Catch
 {  # Start Catch,  Alert Team about VHDX files
  Write-Warning "Error"
  Write-Warning $MailSubject = " VHDX-Checker Rapport $($LogFileDate) - ERROR" # MailSubject
  Write-Output $Error[0];
  Write-Output $MailBody = "Could not alert team about VHDX images that has been affected during the script. $($Error[0]); For more details see the log file $TranScriptLogFile" # MailBody    
       $SmtpServer = ""
       $MailFrom = ""
       $MailTo = ""
  Send-MailMessage -To $MailTo -From $MailFrom -Subject $MailSubject -Body $MailBody -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8)        
 }  # End Catch,  Alert Team about VHDX files

    
 
 # ------------------------------- End Script -------------------------------
 Stop-Transcript
