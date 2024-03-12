
Start-Transcript -Path "$PSScriptRoot\RemoveAccountLog.txt"
Get-Date -Format "yyyy-mm-dd HH:MM"
 Try
  { # Start Try, Get Sid and translate them
   $GetSids = Get-WmiObject -Class Win32_UserProfile | Select-Object Sid, @{Label='LastUseTime';Expression={$_.ConvertToDateTime($_.LastUseTime)}} 
    ForEach ($UserSid in $GetSids)
    { # Start ForEach ($UserSid in $GetSids)      
     $SID = New-Object System.Security.Principal.SecurityIdentifier($UserSid.sid)            
     $UserAccount = $SID.Translate([System.Security.Principal.NTAccount])            
     $Profile = $UserAccount.value.split("\")[1];  

     Write-Host $SID, $Profile, $UserSid.LastUseTime
   } # End ForEach ($UserSid in $GetSids) 
    
  } # End Try, Get Sid and translate them

Catch
  {  # Start Catch
   Write-Warning -Message "## ERROR## " 
   Write-Warning -Message "## Script could not start ## " 
   Write-Warning $Error[0]
  }  # End Catch

Stop-Transcript

