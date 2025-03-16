<#
 Beskrivning : 
   Skriptet exporterar på databas-tabellen [dbo].[Servers] till en csv fil.
   Tabellen finns i databasen Ateam.
   Tabellens kolumner som exporteras är 
    ID
    Servername
    ServerFQDN
    Ipadress
    ServiceName
#>

$TranscriptLogfile = "$PSScriptRoot\Logs\TranscriptExportSQLDataLog.txt"
$ServerListCsvFile = "$PSScriptRoot\Data\Out\ServerListCsv\Serverlist.csv"

Start-Transcript -Path $TranscriptLogfile -Force
Try 
  { # Start Try, Export data from SQL 
   Invoke-Sqlcmd -Query "SELECT * FROM [Ateam].[dbo].[Servers]" -ServerInstance ".\SQLEXPRESS" | 
   Select-Object ID, Servername, ServerFQDN, Ipadress, ServiceName |
   Export-Csv $ServerListCsvFile -force -NoTypeInformation -Delimiter ","
  } # End Try, Export data from SQL 

Catch 
  { # Start Catch, Export data from SQL 
   
    Write-Warning -Message "Could not run Script"
    Write-Warning $Error[0]

  } # End Catch, Export data from SQL 


Stop-Transcript