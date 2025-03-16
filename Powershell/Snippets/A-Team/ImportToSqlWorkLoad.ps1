 $HealthServiceCsv = "$PSScriptRoot\Data\Out\ServerListCsv\Serverlist.csv" # Change Csv file to D:\PSscript\Web-Dashboard\A-Team\Data\In\ServiceCheck\Healthservice\*

 # SQL Settings 
$SQLInstance = ".\SQLEXPRESS"
$SQLDatabase = "Ateam"
$SQLTable = "Workload"




 Start-Transcript -Path "$PSScriptRoot\Logs\TranscriptSQLLog.txt" -Force

  Try
 { # Start Try, Import SaveServiceStatusCsvFile to DB Dbo.Workload
  
   # Import Csv to database
   $ImportHealthServiceCsvFile = Import-Csv -path $HealthServiceCsv -Delimiter "," -Encoding UTF8
   ForEach ($CSVLine in $ImportHealthServiceCsvFile) 
    { # Start ForEach ($CSVLine in $ImportHealthServiceCsvFile)
     # "id","Servername","Ipadress","ServiceName","Status,ServerFQDN"
      $CSVID = $CSVLine.id
      $CSVServername = $CSVLine.Servername
      $CSVIpadress = $CSVLine.Ipadress
      $CSVServiceName = $CSVLine.ServiceName
      $CSVServerStatus = $CSVLine.Status
      $CSVServerFQDN = $CSVLine.ServerFQDN


      # Insert in database
      $SQLInsert = "USE $SQLDatabase
      INSERT INTO $SQLTable (id, Servername, Ipadress, ServiceName )
      VALUES('$CSVID', '$CSVServername', '$CSVIpadress', '$CSVServiceName');"
      # Running the INSERT Query
      Invoke-SQLCmd -Query $SQLInsert -ServerInstance $SQLInstance

    } # End ForEach ($CSVLine in $ImportHealthServiceCsvFile)
 
 } # End Try, Import SaveServiceStatusCsvFile to DB Dbo.Workload

 Catch
 { # Start Catch
 Write-Warning -Message "Could not get import service to SQL "
 Write-Warning $Error[0]
 } # End Catch




 Stop-Transcript



 <#






 











 CSVImport = Import-CSV $CSVFileName
$CSVRowCount = $CSVImport.Count
##############################################
# ForEach CSV Line Inserting a row into the Temp SQL table
##############################################
"Inserting $CSVRowCount rows from CSV into SQL Table $SQLTempTable"

##############################################
# SQL INSERT of CSV Line/Row
##############################################

}



 New-Object PsObject -Prop @{ # Start NewObject
      PSComputerName = $_.PSComputerName
      ServiceName = $_.ServiceName
      Status = $_.Status
     } # End New-Object
  $InputData = [PsCustomObject] @{ # Start PsCustomObject
      ID = $_.ID
      PSComputerName = $_.PSComputerName
      ServiceName = $_.ServiceName
      Status = $_.Status
  } # End PsCustomObject


| ForEach-Object { # Start ForEach-Object
  
    Write-SqlTableData -ServerInstance ".\SQLEXPRESS" -DatabaseName "Ateam" -SchemaName "dbo" -TableName "WorkLoad" -InputData $InputData
   } # End ForEach-Object

   # Remove Old Jobsin [Ateam].[dbo].[WorkLoad]"
 #   Invoke-Sqlcmd -ServerInstance ".\SQLEXPRESS" -Database Ateam -Query "Truncate Table [Ateam].[dbo].[WorkLoad]"   
# Invoke-Sqlcmd -Query "SELECT * FROM [Ateam].[dbo].[Servers]" |Select-Object ID, Servername, ServerFQDN, Ipadress, ServiceName | Export-Csv "D:\PSscript\Web-Dashboard\A-Team\Data\Out\ServerListCsv\Serverlist.csv" -force -NoTypeInformation -Delimiter ","
# Invoke-Sqlcmd -Query "SELECT * FROM [Ateam].[dbo].[Servers]"  |Select-Object ID, Servername, ServerFQDN, Ipadress, ServiceName | Export-Csv "D:\PSscript\Web-Dashboard\A-Team\Data\Out\ServerListCsv\Serverlist.csv" -force -NoTypeInformation -Delimiter ","
 
 #>