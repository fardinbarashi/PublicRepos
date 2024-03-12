

$TranscriptLogfile = "$PSScriptRoot\TranscriptExportSQLDataLog.txt"
$SaveSQLDataAsCsvPath = "$PSScriptRoot\ExportTableFromSqlToCsvFile.csv"

Start-Transcript -Path $TranscriptLogfile -Force
Try 
  { # Start Try, Export data from SQL 
   Invoke-Sqlcmd -Query "SELECT * FROM [DATABASENAME].[dbo].[TABLENAME]" -ServerInstance ".\SQLEXPRESS" | 
   # Select the ColumnName FROM SQL
   Select-Object ID, Column1, Column2, Column3, Column4, Column5 |
   Export-Csv $SaveSQLDataAsCsvPath -force -NoTypeInformation -Delimiter ","
  } # End Try, Export data from SQL 

Catch 
  { # Start Catch, Export data from SQL 
   
    Write-Warning -Message "Could not run Script"
    Write-Warning $Error[0]

  } # End Catch, Export data from SQL 


Stop-Transcript