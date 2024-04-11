$ScriptName = $MyInvocation.MyCommand.Name
$LogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\Logs\$ScriptName - $LogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Get-Date -Format "yyyy/MM/dd HH:mm:ss"
Write-Host ".. Starting TranScript"

# Regedit Settings
  $Key = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\SecurityProviders\SCHANNEL\Protocols\TLS 1.2\Client"

Try 
 { # Start Try
    # Test of Path exist in Regedit
    $TestPath = Test-Path -Path "Registry::$Key"
      if ($TestPath -Eq $True)
       { # Start If, $TestPath -Eq $True)
        Write-host "TestPath exist, get Itemproperties" -ForegroundColor Green        
        
        $GetRegEditValue1 = Get-ItemPropertyValue -Path "Registry::$Key" -Name "DisabledByDefault" -Verbose
        $GetRegEditValue2 = Get-ItemPropertyValue -Path "Registry::$Key" -Name "Enabled" -Verbose
        # Check GetRegEditValue1 
        if ( $GetRegEditValue1 -Eq 1 ) 
         { # Start If ($GetRegEditValue1 -Eq 1 ) 
            Write-host "$GetRegEditValue1 value is 1" -ForegroundColor Green
         }  # Start If ($GetRegEditValue1 -Eq 1 ) 
        else 
         { # Start If, else ($GetRegEditValue1 -Eq 1 ) 
            Write-host "$GetRegEditValue1 value is null" -ForegroundColor Yellow
         } # Start If, else ($GetRegEditValue1 -Eq 1 ) 
        
        # Check GetRegEditValue2 
        if ($GetRegEditValue2 -Eq 1 ) 
        { # Start If ($GetRegEditValue2 -Eq 1 ) 
            Write-host "$GetRegEditValue2 value is 1" -ForegroundColor Green
        }  # Start If ($GetRegEditValue2 -Eq 1 ) 
        else 
        { # Start If,else ($GetRegEditValue2 -Eq 1 ) 
            Write-host "$GetRegEditValue2 value is null" -ForegroundColor Yellow
        } # Start If,else ($GetRegEditValue2 -Eq 1 ) 
       } # End If $TestPath -Eq $True)

      Else
       { # Start Else, $TestPath -Eq $True)
         return $false
       } # End Else $TestPath -Eq $True)
 } # End Try

Catch 
 { 
  # Catch the errors
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Warning $Error[0]
  Write-Host "Stopping Transcript and Script!" -ForegroundColor Red
  Stop-Transcript
  Exit 1
 }
 

 
