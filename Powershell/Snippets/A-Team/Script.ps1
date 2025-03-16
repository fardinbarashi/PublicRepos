CLS
 # SQL Settings 
$SqlInstance = ".\SQLEXPRESS"
$Database = "ServiceChecker"
$DboServerList = "ServerList"
$DboWorkLoad = "Workload"

$TranscriptLogfile = "$PSScriptRoot\Logs\Transcript.txt"

Start-Transcript -Path $TranscriptLogfile -Force
Try 
 { # Start Try, GetDboServerList
 Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "Get id, Servername, ServerFQDN , Ipadress , ServiceName From ServerInstance : $SQLInstance, Database : $Database, Dbo : $DboServerList... 0%" -ForegroundColor Yellow
  $GetDboServerList = Invoke-Sqlcmd -Query "SELECT * FROM [$Database].[dbo].[$DboServerList]" -ServerInstance "$SqlInstance" | 
   Select-Object ID, Servername, ServerFQDN, Ipadress, ServiceName | ForEach { # Start Foreach
    # "id","Servername","ServerFQDN","Ipadress","ServiceName"  
     New-Object PsObject -Prop @{# Start New Object 
          id = $_.id;
          Servername = $_.Servername;
          ServerFQDN = $_.ServerFQDN;
          Ipadress = $_.Ipadress;
          ServiceName = $_.ServiceName;
         }#End New Object
     } # End Foreach
  Write-Host "Get id, Servername, ServerFQDN , Ipadress , ServiceName From ServerInstance : $SQLInstance, Database : $Database, Dbo : $DboServerList... 100%" -ForegroundColor Green
  Write-Host ""
 } # End Try, GetDboServerList

Catch 
 { # Start Catch, GetFromSqlDB
  $ErrorMessage= "Error, GetDboServerList have failed, for more information check the log $TranscriptLogfile."
  Write-Warning -Message $ErrorMessage
  Write-Warning $Error[0]

  # Stop-Transcript
#  $MailSubject = "  Test-Error  "  
#  $MailBody = ""
#  $MailAttachments =    
#  Send-MailMessage -To $Mailto -from "$MailFrom" -Subject $MailSubject -Body $MailBody -Attachments $MailAttachments -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8)       
 } # End Catch, GetFromSqlDB
     

Try 
 { # Start Try, Check Services on servers
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "Get-Services PSComputerName, ServiceName, Status From Dbo : $DboServerList... 0%" -ForegroundColor Yellow
   Foreach ( $ID in $GetFromSqlDB )
    { # Start Foreach 
      $GetSqlWorkLoad = Invoke-Command -ScriptBlock { 
       Get-Service $args[0];} -ComputerName $GetDboServerList.ServerFQDN -ArgumentList $GetDboServerList.ServiceName.Split(",") |
       Select-Object PSComputerName, ServiceName, Status |  Where-Object { $_.Status -Eq "Running" } 
    } # End Foreach 
  Write-Host "Get-Services PSComputerName, ServiceName, Status From Dbo : $DboServerList... 100%" -ForegroundColor Green
  Write-Host ""
 } # End Try,  Check Services on servers

Catch 
 { # Start Catch,  Check Services on servers
  $ErrorMessage= "Error,  Get-Services on servers have failed, for more information check the log $TranscriptLogfile."
  Write-Warning -Message $ErrorMessage
  Write-Warning $Error[0]

#  $MailSubject = "  Test-Error  "  
#  $MailBody = ""
#  $MailAttachments =    
#  Send-MailMessage -To $Mailto -from "$MailFrom" -Subject $MailSubject -Body $MailBody -Attachments $MailAttachments -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8)       
 } # End Catch,  Check Services on servers


Try 
 { # Start Try, Create Workload Dbo
  Get-Date -Format "yyyy/MM/dd HH:mm:ss"
  Write-Host "Create Workload Dbo : $DboWorkLoad... 0%" -ForegroundColor Yellow

  Write-Host "Checking if Workload exist from a previous run."
  # If exsist, Drop table then create, populate
  
  # Else, Create and populate 
    
  Write-Host "Create Workload Dbo : $DboWorkLoad... 100%" -ForegroundColor  Green
  Write-Host ""
 } # End Try, Create Workload Dbo

Catch 
 { # Start Catch, Create Workload Dbo
  $ErrorMessage= "Error, Could not Create Workload Dbo : $DboWorkLoad, for more information check the log $TranscriptLogfile."
  Write-Warning -Message $ErrorMessage
  Write-Warning $Error[0]

#  $MailSubject = "  Test-Error  "  
#  $MailBody = ""
#  $MailAttachments =    
#  Send-MailMessage -To $Mailto -from "$MailFrom" -Subject $MailSubject -Body $MailBody -Attachments $MailAttachments -SmtpServer $SmtpServer -Encoding ([System.Text.Encoding]::UTF8)       
 } # End Catch, Create Workload Dbo




 Stop-Transcript