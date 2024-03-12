Import-Module ActiveDirectory

# Start Transcript
$ScriptName = $MyInvocation.MyCommand.Name
$TranScriptLogFileDate = (Get-Date -Format yyyy/MM/dd/HH.mm.ss)
$TranScriptLogFile = "$PSScriptRoot\$ScriptName - $TranScriptLogFileDate.Txt" 
$StartTranscript = Start-Transcript -Path $TranScriptLogFile -Force
Write-Host "Start Transcript"
Get-Date -Format "yyyy/MM/dd HH:mm:ss"

$AdGroup = "TYPE IN AD-GROUP NAME"
$GetObjectsinAdGroup = Get-ADGroupMember -Identity $AdGroup | Select-Object Name
$SourceFile = "ENTER PATH TO SourceFile"
$DestinationFile = "ENTER PATH TO DestinationFile"
foreach ( $ADComputer in $GetObjectsinAdGroup ) 
 { # Start foreach ( $ADComputer in $GetObjectsinAdGroup ) 
  $GetTestNetConnection = Test-NetConnection -ComputerName $ADComputer.Name
   If (  $GetTestNetConnection -eq $null) 
    { # Start If (  $GetTestNetConnection -eq $null) 
     Get-Date -Format "yyyy/MM/dd HH:mm:ss"
     Write-Host "Trying to connect with "$ADComputer.Name
     Write-Host $ADComputer.Name "is offline" -ForegroundColor Red
     Write-Host "-----------------------------------------------------" 
    } # End If (  $GetTestNetConnection -eq $null) 
   Else 
    { # Start Else (  $GetTestNetConnection -eq $null) 
   Get-Date -Format "yyyy/MM/dd HH:mm:ss"
   Write-Host "Trying to connect with "$ADComputer.Name
   Write-Host $ADComputer.Name "Is Online!, Trying to copy file" -ForegroundColor Green
   Copy-Item $SourceFile -Destination \\$ADComputer\$DestinationFile -Force
   Write-Host "-----------------------------------------------------"     
    } # Start Else (  $GetTestNetConnection -eq $null) 
} # End foreach ( $ADComputer in $GetObjectsinAdGroup ) 
Write-Host "End Transcript" 
Stop-Transcript